" different from keymap in vimneat.vim
" this file of keymaps is more personality with using <space> leader


for s:index in range(10)
	let s:key = '' . s:index
	if s:index == 10 | let s:key = '0' | endif
	exec 'noremap <space>'.s:key.' :Vimmake ' . s:key . '<cr>'
	exec 'noremap <tab>'.s:key.' :Vimmake! ' . s:key . '<cr>'
endfor


" svn shortcut
noremap <space>sc :!svn co -m "update from vim"<cr>
noremap <space>su :!svn up<cr>
noremap <space>st :!svn st<cr>

" toggle plugins
noremap <space>tt :TagbarToggle<cr>
noremap <space>tq :call ToggleQuickFix()<cr>
noremap <silent><F10> :call ToggleQuickFix()<cr>
inoremap <silent><F10> <C-o>:call ToggleQuickFix()<cr>

" open tools
noremap <silent><space>od :call Open_Dictionary("<C-R>=expand("<cword>")<cr>")<cr>



