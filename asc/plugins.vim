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
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
set completeopt=menu


"-----------------------------------------------------
" Tabbar
"-----------------------------------------------------
let g:Tagbar_title = "[Tagbar]"
let g:tagbar_vertical = 28



