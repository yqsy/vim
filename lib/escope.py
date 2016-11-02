#! /usr/bin/env python
# -*- coding: utf-8 -*-
#======================================================================
#
# escope.py - 
#
# Created by skywind on 2016/11/02
# Last change: 2016/11/02 18:12:09
#
#======================================================================
import sys
import time
import os
import hashlib


#----------------------------------------------------------------------
# execute and capture
#----------------------------------------------------------------------
def execute(args, shell = False, capture = False):
	import sys, os
	parameters = []
	if type(args) in (type(''), type(u'')):
		import shlex
		cmd = args
		if sys.platform[:3] == 'win':
			ucs = False
			if type(cmd) == type(u''):
				cmd = cmd.encode('utf-8')
				ucs = True
			args = shlex.split(cmd.replace('\\', '\x00'))
			args = [ n.replace('\x00', '\\') for n in args ]
			if ucs:
				args = [ n.decode('utf-8') for n in args ]
		else:
			args = shlex.split(cmd)
	for n in args:
		if sys.platform[:3] != 'win':
			replace = { ' ':'\\ ', '\\':'\\\\', '\"':'\\\"', '\t':'\\t', \
				'\n':'\\n', '\r':'\\r' }
			text = ''.join([ replace.get(ch, ch) for ch in n ])
			parameters.append(text)
		else:
			if (' ' in n) or ('\t' in n) or ('"' in n): 
				parameters.append('"%s"'%(n.replace('"', ' ')))
			else:
				parameters.append(n)
	cmd = ' '.join(parameters)
	if sys.platform[:3] == 'win' and len(cmd) > 255:
		shell = False
	if shell and (not capture):
		os.system(cmd)
		return ''
	elif (not shell) and (not capture):
		import subprocess
		if 'call' in subprocess.__dict__:
			subprocess.call(args)
			return ''
	import subprocess
	if 'Popen' in subprocess.__dict__:
		if sys.platform[:3] != 'win' and shell:
			p = None
			stdin, stdouterr = os.popen4(cmd)
		else:
			p = subprocess.Popen(args, shell = shell,
					stdin = subprocess.PIPE, stdout = subprocess.PIPE, 
					stderr = subprocess.STDOUT)
			stdin, stdouterr = (p.stdin, p.stdout)
	else:
		p = None
		stdin, stdouterr = os.popen4(cmd)
	text = stdouterr.read()
	stdin.close()
	stdouterr.close()
	if p: p.wait()
	if not capture:
		sys.stdout.write(text)
		sys.stdout.flush()
		return ''
	return text


#----------------------------------------------------------------------
# configure
#----------------------------------------------------------------------
class configure (object):

	def __init__ (self, ininame = None):
		self.ininame = ininame
		self.unix = (sys.platform[:3] != 'win')
		self.config = {}
		self.dirhome = None
		self.rc = None
		self._search_config()
		self._search_binary()
		self.dirhome = self.abspath(self.dirhome)
		if self.dirhome != None:
			self.config['default']['home'] = self.dirhome
		self._search_rc()
		rc = self.option('default', 'rc', None)
		if rc and os.path.exists(rc):
			self.rc = self.abspath(rc)
		self.config['default']['rc'] = rc
		self.exename = {}
		if self.unix:
			f = lambda n: os.path.join(self.dirhome, n)
		else:
			g = lambda n: os.path.join(self.dirhome, n + '.exe')
			f = lambda n: os.path.abspath(g(n))
		self.exename['gtags'] = f('gtags')
		self.exename['global'] = f('global')
		self.exename['gtags-cscope'] = f('gtags-cscope')
		self.GetShortPathName = None
		self.database = None

	def _search_config (self):
		self.config = {}
		self.config['default'] = {}
		if self.ininame and os.path.exists(self.ininame):
			self._read_ini(self.ininame)
			return 0
		fullname = os.path.abspath(__file__)
		testname = os.path.splitext(fullname)[0] + '.ini'
		if os.path.exists(testname):
			self._read_ini(testname)
			self.ininame = testname
		if self.unix:
			self._read_ini('/etc/escope.ini')
			self._read_ini('/usr/local/etc/escope.ini')
		self._read_ini(os.path.expanduser('~/.config/escope.ini'))
		return 0

	def _read_ini (self, filename):
		import ConfigParser
		if not os.path.exists(filename):
			return -1
		fp = open(filename, 'r')
		cp = ConfigParser.ConfigParser(fp)
		for sect in cp.sections():
			if not sect in self.config:
				self.config[sect] = {}
			for key, value in cp.items(sect):
				self.config[sect.lower()][key.lower()] = value
		fp.close()
		return 0

	def option (self, sect, item, default = None):
		if not sect in self.config:
			return default
		return self.config[sect].get(item, default)

	def _test_home (self, path):
		if not os.path.exists(path):
			return False
		if self.unix:
			if not os.path.exists(os.path.join(path, 'gtags')):
				return False
			if not os.path.exists(os.path.join(path, 'global')):
				return False
			if not os.path.exists(os.path.join(path, 'gtags-cscope')):
				return False
		else:
			if not os.path.exists(os.path.join(path, 'gtags.exe')):
				return False
			if not os.path.exists(os.path.join(path, 'global.exe')):
				return False
			if not os.path.exists(os.path.join(path, 'gtags-cscope.exe')):
				return False
		return True

	def _search_binary (self):
		dirhome = self.option('default', 'home')
		if dirhome:
			if self._test_home(dirhome):
				self.dirhome = os.path.abspath(dirhome)
				return 0
		dirhome = os.path.abspath(os.path.dirname(__file__))
		if self._test_home(dirhome):
			self.dirhome = dirhome
			return 0
		PATH = os.environ.get('PATH', '').split(self.unix and ':' or ';')
		for path in PATH:
			if self._test_home(path):
				self.dirhome = os.path.abspath(path)
				return 0
		return -1

	def abspath (self, path):
		if path == None:
			return None
		if '~' in path:
			path = os.path.expanduser(path)
		path = os.path.abspath(path)
		if not self.unix:
			return path.lower().replace('\\', '/')
		return path

	def _search_rc (self):
		rc = self.option('default', 'rc', None)
		if rc != None:
			rc = self.abspath(rc)
			if os.path.exists(rc):
				self.config['default']['rc'] = rc
				return 0
		rc = self.abspath('~/.globalrc')
		if os.path.exists(rc):
			self.config['default']['rc'] = rc
			return 0
		if self.unix:
			rc = '/etc/gtags.conf'
			if os.path.exists(rc):
				self.config['default']['rc'] = rc
				return 0
			rc = '/usr/local/etc/gtags.conf'
			if os.path.exists(rc):
				self.config['default']['rc'] = rc
				return 0
		if self.dirhome == None:
			return -1
		rc = os.path.join(self.dirhome, '../share/gtags/gtags.conf')
		rc = self.abspath(rc)
		if os.path.exists(rc):
			self.config['default']['rc'] = rc
		return -1

	def pathshort (self, path):
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

	def mkdir (self, path):
		path = os.path.abspath(path)
		if os.path.exists(path):
			return 0
		name = ''
		part = os.path.abspath(path).replace('\\', '/').split('/')
		if self.unix:
			name = '/'
		if (not self.unix) and (path[1:2] == ':'):
			part[0] += '/'
		for n in part:
			name = os.path.abspath(os.path.join(name, n))
			if not os.path.exists(name):
				os.mkdir(name)
		return 0

	def execute (self, name, args, capture = False):
		if name in self.exename:
			name = self.exename[name]
		name = self.pathshort(name)
		return execute([name] + args, False, capture)

	def init (self):
		if self.dirhome == None:
			raise Exception('Cannot find GNU Global in $PATH or config')
		if os.path.exists(self.rc):
			os.environ['GTAGSCONF'] = os.path.abspath(self.rc)
		PATH = os.environ.get('PATH', '')
		if self.unix:
			PATH = self.dirhome + ':' + PATH
		else:
			PATH = os.path.abspath(self.dirhome) + ';' + PATH
		os.environ['PATH'] = PATH
		database = self.option('default', 'database', None)
		if not database:
			database = self.abspath('~/.local/var/escope')
		self.mkdir(database)
		if not os.path.exists(database):
			raise Exception('Cannot create database folder: %s'%database)
		self.database = database
		return 0

	def pathdb (self, root):
		root = root.strip()
		root = self.abspath(root)
		hash = hashlib.md5(root).hexdigest()
		path = os.path.abspath(os.path.join(self.database, hash))
		return (self.unix) and path or path.replace('\\', '/')

	def select (self, root):
		root = root.strip()
		root = self.abspath(root)
		db = self.pathdb(root)
		self.mkdir(db)
		os.environ['GTAGSROOT'] = os.path.abspath(root)
		os.environ['GTAGSDBPATH'] = os.path.abspath(db)
		return db



#----------------------------------------------------------------------
# testing case
#----------------------------------------------------------------------
if __name__ == '__main__':
	def test1():
		config = configure()
		config.init()
		print config.select('e:/lab/casuald\\src/')
		print os.environ['GTAGSROOT']
		print os.environ['GTAGSDBPATH']
		return 0

	test1()



