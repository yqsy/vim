"======================================================================
"
" menu.vim - 
"
" Created by skywind on 2017/07/06
" Last change: 2017/07/06 16:59:26
"
"======================================================================

function! menu#FindInProject()
	let p = vimmake#get_root('%')
	let t = expand('<cword>')
	echohl Type
	call inputsave()
	let t = input('find word ('. p.'): ', t)
	call inputrestore()
	echohl None
	if strlen(t) > 0
		silent exec "GrepCode! ".fnameescape(t)
	endif
endfunc

function! menu#CodeCheck()
	if &ft == 'python'
		call asclib#lint_pylint('')
	elseif &ft == 'c' || &ft == 'cpp'
		call asclib#lint_cppcheck('')
	else
		call asclib#errmsg('file type unsupported, only support python/c/cpp')
	endif
endfunc

function! menu#DelimitSwitch(on)
	if a:on
		exec "DelimitMateOn"
	else
		exec "DelimitMateOff"
	endif
endfunc

function! menu#TogglePaste()
	if &paste
		set nopaste
	else
		set paste
	endif
endfunc

function! menu#CurrentWord(limit)
	let text = expand('<cword>')
	if len(text) < a:limit
		return text
	endif
	return text[:a:limit] . '..'
endfunc

function! menu#CurrentFile(limit)
	let text = expand('%:t')
	if len(text) < a:limit
		return text
	endif
	return text[:a:limit] . '..'
endfunc


"----------------------------------------------------------------------
" menu initialize
"----------------------------------------------------------------------

let g:quickmenu_options = 'L'

call quickmenu#reset()


call quickmenu#append('# Find', '')

call quickmenu#append('Grep "%{menu#CurrentWord(12)}"', 'call menu#FindInProject()')

call quickmenu#append('Stop Searching', 'VimStop')

call quickmenu#append('Tag View "%{menu#CurrentWord(10)}"', 'call asclib#preview_tag(expand("<cword>"))')


call quickmenu#append('# Debug', '')

call quickmenu#append('Run "%{menu#CurrentFile(12)}"', 'VimExecute run')

call quickmenu#append('Compile "%{menu#CurrentFile(12)}"', 'VimBuild gcc')

call quickmenu#append('Code Static Check', 'call menu#CodeCheck()')

call quickmenu#append('# Settings', '')

call quickmenu#append('Set paste %{&paste? "off" :"on"}', 'call menu#TogglePaste()')


