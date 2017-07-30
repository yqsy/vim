"======================================================================
"
" asynctask.vim - 
"
" Created by skywind on 2017/07/30
" Last change: 2017/07/30 14:59:19
"
"======================================================================

let s:task = {}

function! s:task.new(name, callback)
	let newobj = copy(self)
	let newobj.name = name
	let newobj.cb = callback
	return newobj
endfunc


"----------------------------------------------------------------------
" internal state
"----------------------------------------------------------------------
let s:windows = has('win32') || has('win64') || has('win95') || has('win16')
let s:support = 0
let s:nvim = has('nvim')

" check has advanced mode
if (v:version >= 800 || has('patch-7.4.1829')) && (!has('nvim'))
	if has('job') && has('channel') 
		let s:support = 1
	endif
elseif has('nvim')
	let s:support = 1
endif


