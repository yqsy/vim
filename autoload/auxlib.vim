"======================================================================
"
" auxlib.vim - python + vim
"
" Created by skywind on 2016/11/07
" Last change: 2016/11/07 11:57:54
"
"======================================================================
if !has('python')
	finish
endif

let s:filename = expand('<sfile>:p')
let s:filehome = expand('<sfile>:p:h')

python << __EOF__
def __auxlib_initialize():
	import os, sys, vim
	filename = os.path.abspath(vim.eval('expand("<sfile>:p")'))
	filehome = os.path.abspath(os.path.dirname(filename))
	if not filehome in sys.path:
		sys.path.append(filehome)
	return 0

__auxlib_initialize()
import auxlib

__EOF__



