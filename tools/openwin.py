#! /usr/bin/python
import sys, os, time
import subprocess


#----------------------------------------------------------------------
# configure
#----------------------------------------------------------------------
class configure (object):

	def __init__ (self):
		self.dirhome = os.path.abspath(os.path.dirname(__file__))
		self.diruser = os.path.abspath(os.path.expanduser('~'))
		self.unix = sys.platform[:3] != 'win' and True or False
		self.temp = os.environ.get('temp', os.environ.get('tmp', '/tmp'))
		self.tick = long(time.time()) % 100
		self.temp = os.path.join(self.temp, 'winex_%02d.cmd'%self.tick)
		self.GetShortPathName = None
	
	def escape (self, path):
		path = path.replace('\\', '\\\\').replace('"', '\\"')
		return path.replace('\'', '\\\'')
		
	def darwin_osascript (self, script):
		for line in script:
			#print line
			pass
		if type(script) == type([]):
			script = '\n'.join(script)
		p = subprocess.Popen(['/usr/bin/osascript'], shell = False,
				stdin = subprocess.PIPE, stdout = subprocess.PIPE,
				stderr = subprocess.STDOUT)
		p.stdin.write(script)
		p.stdin.flush()
		p.stdin.close()
		text = p.stdout.read()
		p.stdout.close()
		code = p.wait()
		return code, text

	def darwin_open_terminal (self, title, script, profile = None):
		osascript = []
		command = []
		for line in script:
			line = line.replace('\\', '\\\\')
			line = line.replace('"', '\\"')
			line = line.replace("'", "\\'")
			command.append(line)
		command = '; '.join(command)
		osascript.append('tell application "Terminal"')
		osascript.append('     do script "%s; exit"'%command)
		x = '     set current settings of selected tab of '
		x += 'window 1 to settings set "%s"'
		if profile != None:
			osascript.append(x%profile)
		osascript.append('     activate')
		osascript.append('end tell')
		return self.darwin_osascript(osascript)

	def darwin_open_iterm (self, title, script, profile = None):
		osascript = []
		command = []
		for line in script:
			line = line.replace('\\', '\\\\\\\\')
			line = line.replace('"', '\\\\\\"')
			line = line.replace("'", "\\\\\\'")
			command.append(line)
		command = '; '.join(command)
		osascript.append('tell application "iTerm"')
		osascript.append('set myterm to (make new terminal)')
		osascript.append('tell myterm')
		osascript.append('set mss to (make new session at the end of sessions)')
		osascript.append('tell mss')
		osascript.append('     set name to "%s"'%self.escape(title))
		osascript.append('     activate')
		osascript.append('     exec command "/bin/bash -c \\"%s\\""'%command)
		osascript.append('end tell')
		osascript.append('end tell')
		osascript.append('end tell')
		return self.darwin_osascript(osascript)
	
	def unix_escape (self, argument, force = False):
		argument = argument.replace('\\', '\\\\')
		argument = argument.replace('"', '\\"')
		argument = argument.replace("'", "\\'")
		return argument.replace(' ', '\\ ')

	def win32_escape (self, argument, force = False):
		if force == False and argument:
			clear = True
			for n in ' \n\r\t\v\"':
				if n in argument:
					clear = False
					break
			if clear:
				return argument
		output = '"'
		size = len(argument)
		i = 0
		while True:
			blackslashes = 0
			while (i < size and argument[i] == '\\'):
				i += 1
				blackslashes += 1
			if i == size:
				output += '\\' * (blackslashes * 2)
				break
			if argument[i] == '"':
				output += '\\' * (blackslashes * 2 + 1)
				output += '"'
			else:
				output += '\\' * blackslashes
				output += argument[i]
			i += 1
		output += '"'
		return output

	def win32_path_short (self, path):
		path = os.path.abspath(path)
		if self.unix:
			return path
		if not self.GetShortPathName:
			self.kernel32 = None
			self.textdata = None
			try:
				import ctypes
				self.kernel32 = ctypes.windll.LoadLibrary("kernel32.dll")
				self.textdata = ctypes.create_string_buffer('\000' * 1024)
				self.GetShortPathName = self.kernel32.GetShortPathNameA
				args = [ ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int ]
				self.GetShortPathName.argtypes = args
				self.GetShortPathName.restype = ctypes.c_uint32
			except: pass
		if not self.GetShortPathName:
			return path
		retval = self.GetShortPathName(path, self.textdata, 1024)
		shortpath = self.textdata.value
		if retval <= 0:
			return ''
		return shortpath

	def win32_open_console (self, title, script, profile = None):
		fp = open(self.temp, 'w')
		fp.write('@echo off\n')
		if title:
			fp.write('title %s\n'%self.win32_escape(title))
		for line in script:
			fp.write(line + '\n')
		fp.close()
		fp = None
		pathname = self.win32_path_short(self.temp)
		os.system('start cmd /C %s'%(pathname))
		return 0
	
	def darwin_open_xterm (self, title, script, profile = None):
		command = []
		for line in script:
			line = line.replace('\\', '\\\\')
			line = line.replace('"', '\\"')
			line = line.replace("'", "\\'")
			command.append(line)
		command = '; '.join(command)
		command = 'xterm -T "%s" -e "%s" &'%(title, command)
		subprocess.call(['/bin/sh', '-c', command])
		return 0

	def linux_open_xterm (self, title, script, profile = None):
		command = []
		for line in script:
			command.append(line)
		command = '; '.join(command)
		subprocess.call(['xterm', '-T', title, '-e', command])
		return 0

	def linux_open_gnome (self, title, script, profile = None):
		command = []
		for line in script:
			line = line.replace('\\', '\\\\')
			line = line.replace('"', '\\"')
			line = line.replace("'", "\\'")
			command.append(line)
		command = '; '.join(command)
		command = 'bash -c \"%s\"'%command
		title = self.escape(title)
		if profile == None:
			os.system('gnome-terminal -t "%s" --command=\'%s\''%(title, command))
		else:
			profile = self.escape(profile)
			os.system('gnome-terminal -t "%s" --window-with-profile="%s" --command=\'%s\''%(title, profile, command))
		return 0

	def cygwin_open_cmd (self, title, script, profile = None):
		temp = os.environ.get('TEMP', os.environ.get('TMP', '/tmp'))
		filename = os.path.split(self.temp)[-1]
		cwd = os.getcwd()
		fp = open(os.path.join(temp, filename), 'w')
		fp.write('@echo off\n')
		if title:
			fp.write('title %s\n'%self.win32_escape(title))
		for line in script:
			fp.write(line + '\n')
		fp.close()
		fp = None
		command = 'cygstart cmd /C %s'%(filename)
		p = subprocess.Popen(['cygstart', 'cmd', '/C', filename], cwd = temp)
		p.wait()
		p = None
		return 0


#----------------------------------------------------------------------
# die
#----------------------------------------------------------------------
def die(message):
	sys.stderr.write('%s\n'%message)
	sys.stderr.flush()
	sys.exit(0)
	return 0


#----------------------------------------------------------------------
# open terminal and run script
#----------------------------------------------------------------------
def openterm(terminal, title, script, profile = None):
	cfg = configure()
	if sys.platform[:3] == 'win':
		if script == None:
			return ['cmd']
		cfg.win32_open_console(title, script)
		return 0
	if terminal == None:
		terminal = ''
	terminal = terminal.lower()
	if sys.platform == 'darwin':
		if script == None:
			return ['terminal', 'iterm', 'xterm']
		if terminal in ('terminal', 'system', '', 'default'):
			cfg.darwin_open_terminal(title, script, profile)
		elif terminal in ('iterm', 'iterm2'):
			cfg.darwin_open_iterm(title, script, profile)
		elif terminal in ('xterm'):
			cfg.darwin_open_xterm(title, script, profile)
		else:
			die('bad terminal name: %s'%terminal)
			return -1
		return 0
	else:
		if script == None:
			return ['xterm', 'gnome']
		if terminal in ('xterm', '', 'default', 'system'):
			cfg.linux_open_xterm(title, script, profile)
		elif terminal in ('gnome', 'gnome-terminal'):
			cfg.linux_open_gnome(title, script, profile)
		else:
			die('bad terminal name: %s'%terminal)
			return -1
		return 0
	return 0


#----------------------------------------------------------------------
# execute
#----------------------------------------------------------------------
def execute(terminal, title, command, cwd, wait, profile = None, post = ''):
	script = []
	if sys.platform[:3] == 'win' and cwd[1:2] == ':':
		script.append(cwd[:2])
	script.append('cd "%s"'%cwd)
	script.append(command)
	if wait:
		if sys.platform[:3] == 'win':
			script.append('pause')
		elif sys.platform == 'cygwin' and terminal in ('cmd', 'dos', 'win'):
			script.append('pause')
		else:
			script.append('read -n1 -rsp "press any key to continue ..."')
	if post:
		script.append(post)
	return openterm(terminal, title, script, profile)


#----------------------------------------------------------------------
# main routine
#----------------------------------------------------------------------
def main(argv = None):
	if argv == None:
		argv = sys.argv
	argv = [ n for n in argv ]
	args = []
	cmds = []
	skip = ['-h', '--help', '-w']
	index = 1
	if len(argv) > 0:
		args.append(argv[0])
	while index < len(argv):
		data = argv[index]
		if data[:2] == '--':
			args.append(data)
			index += 1
		elif data in skip:
			args.append(data)
			index += 1
		elif data[:1] == '-':
			args.append(data)
			index += 1
			if index >= len(argv):
				break
			args.append(argv[index])
			index += 1
		else:
			cmds = argv[index:]
			break
	import optparse
	if len(cmds) == 0 and len(args) > 1:
		args.append('--help')
	desc = 'Execute program in a new terminal window'
	parser = optparse.OptionParser( \
			usage = 'usage: %prog [options] command [args ...]',
			version = '0.0.0',
			description = desc)
	parser.add_option('-t', '--title', dest = 'title', default = None,
			help = 'title of new window')
	parser.add_option('-m', '--terminal', dest = 'terminal', default = None, 
			help = 'terminal name to open')
	parser.add_option('-p', '--profile', dest = 'profile', default = None,
			help = 'terminal profile')
	parser.add_option('-c', '--cwd', dest = 'cwd', default = '',
			help = 'working directory')
	parser.add_option('-w', '--wait', dest = 'wait', default = False,
			action = 'store_true', help = 'wait before exit')
	parser.add_option('-o', '--post', dest = 'post', default = '',
			help = 'post action')
	opts, _ = parser.parse_args(args)
	if opts.title == None:
		opts.title = cmds[0]
	if not opts.cwd:
		opts.cwd = os.getcwd()
	command = []
	cfg = configure()
	for n in cmds:
		if sys.platform[:3] == 'win':
			n = cfg.win32_escape(n)
		elif sys.platform == 'cygwin' and opts.terminal in ('dos', 'win', 'cmd'):
			n = cfg.win32_escape(n)
		else:
			n = cfg.unix_escape(n)
		command.append(n)
	command = ' '.join(command)
	execute(opts.terminal, opts.title, command, opts.cwd, opts.wait, 
			opts.profile, opts.post)
	return 0


#----------------------------------------------------------------------
# testing casen
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# testing casen
#----------------------------------------------------------------------
if __name__ == '__main__':
	def test1():
		cfg = configure()
		cfg.darwin_open_terminal('111', ['ls -la /', 'read -n1 -rsp press\\ any\\ key\\ to\\ continue\\ ...', 'echo "fuck you"'])
	
	def test2():
		cfg = configure()
		cfg.darwin_open_iterm2('11111', ['sleep 2', 'read -n1 -rsp press\\ any\\ key\\ to\\ continue...', 'echo "fuck you"', 'sleep 10'])

	def test3():
		cfg = configure()
		cfg.win32_open_console('11111', ['d:', 'cd /acm/github/vim/tools', 'dir', 'pause' ])
		return 0
	
	def test4():
		cfg = configure()
		cfg.linux_open_xterm('1111', ['sleep 2', 'read -n1 -rsp press\\ any\\ key\\ to\\ continue...', 'echo "fuck you"', 'sleep 10'])
		return 0

	def test5():
		cfg = configure()
		cfg.linux_open_gnome('1111', ['sleep 2', 'read -n1 -rsp sdf\\ sdf', 'echo "fuck you"', 'sleep 5'], 'Linwei')
		return 0

	def test6():
		cfg = configure()
		cfg.darwin_open_xterm('1111', ['sleep 2', 'read -n1 -rsp press\\ any\\ key\\ to\\ continue...', 'echo "fuck you"', 'sleep 10'])
		return 0

	def test7():
		execute('', 'test', 'ls .', '~', True)
		return 0

	def test8():
		args = [ __file__, '-p', '123', '-w', '--profile=123', '-c', 'e:/lab', 'dir', '/w' ]
		main(args)
		return 0

	def test9():
		cfg = configure()
		cfg.cygwin_open_cmd('fuck', ['e:', 'cd lab', 'dir', 'pause'])

	test9()




