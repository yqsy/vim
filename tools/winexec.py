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
		self.win32 = sys.platform[:3] == 'win' and True or False
	
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

	def win32_open_console (self, title, script):

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

	test2()




