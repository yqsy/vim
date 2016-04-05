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

	def darwin_open_terminal (self, title, lines, pwd = None):
		if pwd == None:
			pwd = os.getcwd()
		script = []
		command = []
		for line in lines:
			command.append(line.replace('"', '\\"').replace("'", "\\'"))
		command = '; '.join(command)
		pwd = self.escape(pwd).replace(' ', '\\ ')
		script.append('tell application "Terminal"')
		script.append('     do script "cd %s; %s; exit"'%(pwd, command))
		script.append('     activate')
		script.append('end tell')
		return self.darwin_osascript(script)

	def darwin_open_iterm2 (self, title, lines, pwd = None):
		if pwd == None:
			pwd = os.getcwd()
		script = []
		command = []
		for line in lines:
			command.append(line.replace('"', '\\"').replace("'", "\\'"))
		command = '; '.join(command)
		pwd = self.escape(pwd).replace(' ', '\\ ')
		script.append('tell application "iTerm"')
		script.append('set myterm to (make new terminal)')
		script.append('tell myterm')
		script.append('set mss to (make new session at the end of sessions)')
		script.append('talk mss')
		script.append('     set name to "%s"'%self.escape(title))
		script.append('     activate')
		script.append('     exec command "/bin/bash -c \'cd %s; %s;\'"'%(pwd, command))
		script.append('end tell')
		script.append('end tell')
		script.append('end tell')
		for line in script:
			print line
		return self.darwin_osascript(script)


#----------------------------------------------------------------------
# testing case
#----------------------------------------------------------------------
if __name__ == '__main__':
	def test1():
		cfg = configure()
		cfg.darwin_open_terminal('111', ['ls -la /'])
	
	def test2():
		cfg = configure()
		cfg.darwin_open_iterm2('11111', ['ls -la /'])

	test2()




