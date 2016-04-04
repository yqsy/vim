" different from keymap in vimneat.vim
" this file of keymaps is more personality with using <space> leader


for s:index in range(10)
	let s:key = '' . s:index
	if s:index == 10 | let s:key = '0' | endif
	exec 'noremap <space>'.s:key.' :Vimmake ' . s:key . '<cr>'
	exec 'noremap <tab>'.s:key.' :Vimmake! ' . s:key . '<cr>'
endfor


" global settings
let s:winopen = 0
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)
set laststatus=1
set splitright
let g:vimmake_save = 1

function! ToggleQuickFix()
	if s:winopen == 0
		exec "copen 6"
		exec "wincmd k"
		set number
		set laststatus=2
		let s:winopen = 2
	elsei s:winopen == 1
		exec "copen 6"
		exec "wincmd k"
		let s:winopen = 2
	else
		exec "cclose"
		let s:winopen = 1
	endif
endfunc


" svn shortcut
noremap <space>sc :!svn co -m "update from vim"<cr>
noremap <space>su :!svn up<cr>
noremap <space>st :!svn st<cr>

" toggle plugins
noremap <space>tt :TagbarToggle<cr>
noremap <space>tq :call ToggleQuickFix()<cr>
noremap <silent><F10> :call ToggleQuickFix()<cr>
inoremap <silent><F10> <C-o>:call ToggleQuickFix()<cr>



