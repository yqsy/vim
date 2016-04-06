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
		self.temp = os.environ.get('temp', os.environ.get('tmp', '/'))
		self.tick = long(time.time()) % 100
		self.temp = os.path.join(self.temp, 'winex_%02d.cmd'%self.tick)
		self.GetShortPathName = None
	
	def escape (self, path):
		path = path.replace('\\', '\\\\').replace('"', '\\"')
		return path.replace('\'', '\\\'')
		
	def darwin_osascript (self, script):
		for line in script:
			print line
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

	def darwin_open_terminal (self, title, script):
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
		osascript.append('     activate')
		osascript.append('end tell')
		return self.darwin_osascript(osascript)

	def darwin_open_iterm2 (self, title, script):
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

	def win32_open_console (self, title, script):
		fp = open(self.temp, 'w')
		fp.write('@echo off\n')
		for line in script:
			fp.write(line + '\n')
		fp.close()
		fp = None
		pathname = self.win32_path_short(self.temp)
		os.system('start "%s" cmd /C %s'%(title, pathname))
		return 0


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

	test3()




