"======================================================================
"
" menu.vim - 
"
" Created by skywind on 2017/07/06
" Last change: 2017/07/06 16:59:26
"
"======================================================================

function! <SID>FindInProject()
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

function! <SID>CodeCheck()
	if &ft == 'python'
		call asclib#lint_pylint('')
	elseif &ft == 'c' || &ft == 'cpp'
		call asclib#lint_cppcheck('')
	else
		call asclib#errmsg('file type unsupported, only support python/c/cpp')
	endif
endfunc

function! <SID>DelimitSwitch(on)
	if a:on
		exec "DelimitMateOn"
		aunmenu &Assist.Enable\ &Sign\ Help
		amenu <silent> 90.85 &Assist.Disable\ &Sign\ Help :call <SID>DelimitSwitch(0)<cr>
	else
		exec "DelimitMateOff"
		aunmenu &Assist.Disable\ &Sign\ Help
		amenu <silent> 90.85 &Assist.Enable\ &Sign\ Help :call <SID>DelimitSwitch(1)<cr>
	endif
endfunc


amenu <silent> 90.10 &Assist.&Find\ In\ Project :call <SID>FindInProject()<cr>
amenu <silent> 90.15 &Assist.Edit\ &QuickNote :FileSwitch tabe ~/.vim/quicknote.txt<cr>
amenu <silent> 90.85 &Assist.Enable\ &Sign\ Help :call <SID>DelimitSwitch(1)<cr>
amenu <silent> 90.90 &Assist.Static\ Code\ &Check :call <SID>CodeCheck()<cr>


