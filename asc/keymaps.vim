" keymaps is more personality with using <space> leader


for s:index in range(10)
	let s:key = '' . s:index
	if s:index == 10 | let s:key = '0' | endif
	exec 'noremap <space>'.s:key.' :Vimmake ' . s:key . '<cr>'
	exec 'noremap ,'.s:key.' :Vimmake! ' . s:key . '<cr>'
endfor


" svn shortcut
noremap <space>sc :!svn co -m "update from vim"<cr>
noremap <space>su :!svn up<cr>
noremap <space>st :!svn st<cr>

" toggle plugins
noremap <space>tt :TagbarToggle<cr>
noremap <space>tq :call Toggle_QuickFix()<cr>
noremap <silent><F10> :call Toggle_QuickFix()<cr>
inoremap <silent><F10> <C-o>:call Toggle_QuickFix()<cr>
noremap <space>tn :call Toggle_Number()<cr>

" open tools
noremap <silent><space>fd :call Open_Dictionary("<C-R>=expand("<cword>")<cr>")<cr>
noremap <silent><space>fm :!man -S 3:2:1 "<C-R>=expand("<cword>")<CR>"<CR>
noremap <silent><space>fh :call Open_HeaderFile()<cr>

