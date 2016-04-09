"-----------------------------------------------------
" netrw
"-----------------------------------------------------
let g:netrw_liststyle = 1
let g:netrw_list_hide= '.*\.swp$,.*\.pyc,*\.o,*\.bak,\.git,\.svn,\.obj'

" fixed netrw underline bug in vim 7.3 and below
if v:version < 704
	"set nocursorline
	"au FileType netrw hi CursorLine gui=underline
	"au FileType netrw au BufEnter <buffer> hi CursorLine gui=underline
	"au FileType netrw au BufLeave <buffer> hi clear CursorLine
	autocmd BufEnter * if &buftype == '' | :set nocursorline | endif
endif


"-----------------------------------------------------
" YouCompleteMe
"-----------------------------------------------------
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
set completeopt=menu


"-----------------------------------------------------
" Tabbar
"-----------------------------------------------------
let g:Tagbar_title = "[Tagbar]"
let g:tagbar_vertical = 28



