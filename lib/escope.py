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
import json
import hashlib
import datetime


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
		self.unix = (sys.platform[:3] != 'win') and 1 or 0
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

	# search escope config
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

	# read option 
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

	# search gtags executables
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

	# abspath 
	def abspath (self, path, resolve = False):
		if path == None:
			return None
		if '~' in path:
			path = os.path.expanduser(path)
		path = os.path.abspath(path)
		if not self.unix:
			return path.lower().replace('\\', '/')
		if resolve:
			return os.path.abspath(os.path.realpath(path))
		return path

	# search gtags rc
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

	# short name in windows
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

	# recursion make directory
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

	# execute a gnu global executable
	def execute (self, name, args, capture = False):
		if name in self.exename:
			name = self.exename[name]
		name = self.pathshort(name)
		return execute([name] + args, False, capture)

	# initialize environment
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
		if database:
			database = self.abspath(database, True)
		else:
			database = self.abspath('~/.local/var/escope', True)
		if not os.path.exists(database):
			self.mkdir(database)
		if not os.path.exists(database):
			raise Exception('Cannot create database folder: %s'%database)
		self.database = database
		return 0

	# get project db path
	def pathdb (self, root):
		if (self.database == None) or (root == None):
			return None
		root = root.strip()
		root = self.abspath(root)
		hash = hashlib.md5(root).hexdigest().lower()
		path = os.path.abspath(os.path.join(self.database, hash))
		return (self.unix) and path or path.replace('\\', '/')

	# load project desc
	def load (self, root):
		db = self.pathdb(root)
		if db == None:
			return None
		cfg = os.path.join(db, 'config.json')
		if not os.path.exists(cfg):
			return None
		fp = open(cfg, 'r')
		content = fp.read()
		fp.close()
		try:
			obj = json.loads(content)
		except:
			return None
		if type(obj) != type({}):
			return None
		return obj

	# save project desc
	def save (self, root, obj):
		db = self.pathdb(root)
		if db == None or type(obj) != type({}):
			return -1
		cfg = os.path.join(db, 'config.json')
		text = json.dumps(obj, indent = 4)
		fp = open(cfg, 'w')
		fp.write(text)
		fp.close()
		return 0

	def timestamp (self):
		return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

	def get_size (path = '.'):
		total_size = 0
		for dirpath, dirnames, filenames in os.walk(path):
			for f in filenames:
				fp = os.path.join(dirpath, f)
				total_size += os.path.getsize(fp)
		return total_size

	# list all projects in database
	def list (self, garbage = None):
		roots = []
		if garbage == None:
			garbage = []
		if self.database == None:
			return None
		if not os.path.exists(self.database):
			return None
		for name in os.listdir(self.database):
			name = name.strip()
			if len(name) != 32:
				garbage.append(name)
				continue
			path = os.path.join(self.database, name)
			if not os.path.isdir(path):
				garbage.append(name)
				continue
			desc = None
			cfg = os.path.join(path, 'config.json')
			if os.path.exists(cfg):
				try:
					fp = open(cfg, 'r')
					text = fp.read()
					fp.close()
					desc = json.loads(text)
				except:
					desc = None
				if type(desc) != type({}):
					desc = None
			root = (desc != None) and desc.get('root', '') or ''
			if desc == None or root == '':
				garbage.append(name)
				continue
			if desc.get('db', '') == '':
				garbage.append(name)
				continue
			roots.append((name, root, desc))
		return roots

	# select and initialize a project
	def select (self, root):
		if root == None:
			return None
		root = root.strip()
		root = self.abspath(root)
		db = self.pathdb(root)
		self.mkdir(db)
		os.environ['GTAGSROOT'] = os.path.abspath(root)
		os.environ['GTAGSDBPATH'] = os.path.abspath(db)
		desc = self.load(root)
		if desc == None:
			desc = {}
			desc['root'] = root
			desc['db'] = db
			desc['ctime'] = self.timestamp()
			desc['mtime'] = self.timestamp()
			desc['version'] = 0
			desc['size'] = 0
			self.save(root, desc)
		return desc

	# clear invalid files in the database path
	def clear (self):
		if self.database == None:
			return -1
		if not os.path.exists(self.database):
			return -2
		if self.database == '/':
			return -3
		database = os.path.abspath(self.database)
		if len(self.database) == 3 and self.unix == 0:
			if self.database[1] == ':':
				return -4
		garbage = []
		self.list(garbage)
		import shutil
		for name in garbage:
			path = os.path.join(self.database, name)
			if not os.path.exists(path):
				continue
			if os.path.isdir(path):
				shutil.rmtree(path, True)
			else:
				try: os.remove(path)
				except: pass
		return 0


#----------------------------------------------------------------------
# escope - gtags wrapper
#----------------------------------------------------------------------
class escope (object):

	def __init__ (self, ininame = None):
		self.config = configure(ininame)
		self.desc = None
		self.root = None

	def init (self):
		if self.config.database != None:
			return 0
		self.config.init()
		return 0

	def select (self, root):
		self.desc = None
		self.root = None
		desc = self.config.select(root)
		if desc == None:
			return -1
		self.desc = desc
		self.root = self.config.abspath(root)
		return 0

	def generate (self, label = None, update = False, verbose = False):
		if (self.desc == None) or (self.root == None):
			return -1
		args = ['--skip-unreadable']
		if label:
			args += ['--gtagslabel', label]
		if verbose:
			args += ['-v']
		if update:
			args += ['-i']
		db = self.desc['db']
		args += [db]
		cwd = os.getcwd()
		os.chdir(self.root)
		self.config.execute('gtags', args)
		os.chdir(cwd)
		return 0



#----------------------------------------------------------------------
# testing case
#----------------------------------------------------------------------
if __name__ == '__main__':

	def test1():
		config = configure()
		config.init()
		print config.select('e:/lab/casuald/src/')
		print ''
		for hash, root, desc in config.list():
			print hash, root, desc['ctime']
		config.clear()
		return 0

	def test2():
		sc = escope()
		sc.init()
		sc.select('e:/lab/casuald/src/')
		sc.generate(label = 'pygments', update = True, verbose = True)
		return 0

	test2()



