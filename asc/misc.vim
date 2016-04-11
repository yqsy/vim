function! Python_InitTab()
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal shiftwidth=4
	setlocal noexpandtab
endfunc

if has('autocmd')
	filetype plugin indent on
	autocmd! BufNewFile,BufRead *.py call Python_InitTab()
endif

