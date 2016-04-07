if !exists('g:netrw_liststyle_save')
	let g:netrw_liststyle_save = 1
endif

" fixed netrw underline bug in vim 7.3 and below
if v:version < 704
	"set nocursorline
	"au FileType netrw hi CursorLine gui=underline
	"au FileType netrw au BufEnter <buffer> hi CursorLine gui=underline
	"au FileType netrw au BufLeave <buffer> hi clear CursorLine
	autocmd BufEnter * if &buftype == '' | :set nocursorline | endif
endif



