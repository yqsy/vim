"======================================================================
"
" vinegar2.vim - Vinegar & Oil (my own version)
"
" Created by skywind on 2017/06/30
" Last change: 2017/06/30 13:33:48
"
"======================================================================

let s:netrw_up = ''


"----------------------------------------------------------------------
" seek
"----------------------------------------------------------------------
function! s:seek(file) abort
	if get(b:, 'netrw_liststyle') == 2
		let pattern = '\%(^\|\s\+\)\zs'.escape(a:file, '.*[]~\').'[/*|@=]\=\%($\|\s\+\)'
	elseif get(b:, 'netrw_liststyle') == 1
		let pattern = '^'.escape(a:file, '.*[]~\').'[/*|@=]\=\%($\|\s\+\)'
	else
		let pattern = '^\%(| \)*'.escape(a:file, '.*[]~\').'[/*|@=]\=\%($\|\t\)'
	endif
	if has('win32') || has('win16') || has('win95') || has('win64')
		let savecase = &l:ignorecase
		setlocal ignorecase
		if &buftype == 'nofile' && &filetype == 'nerdtree'
			let pattern = '^ *\%(▸ \)\?'.escape(a:file, '.*[]~\').'\>'
		endif
		call search(pattern, 'wc')
		let l:ignorecase = savecase
	else
		if &buftype == 'nofile' && &filetype == 'nerdtree'
			let pattern = '^ *\%(▸ \)\?'.escape(a:file, '.*[]~\').'\>'
		endif
		call search(pattern, 'wc')
	endif
	return pattern
endfunc



"----------------------------------------------------------------------
" open upper directory
"----------------------------------------------------------------------
function! s:open(cmd) abort
	let filename = expand('%:t')
	if &buftype == "nofile" || &buftype == "quickfix"
		return
	elseif &filetype ==# 'netrw'
		if s:netrw_up == ''
			return
		endif
		let currdir = fnamemodify(b:netrw_curdir, ':t')
		execute s:netrw_up
		call s:seek(currdir)
	elseif &filetype ==# 'nerdtree'
		let currdir = b:NERDTreeRoot.path.str()
		exec "normal " . g:NERDTreeMapUpdir
		call s:seek(currdir)
	elseif &modifiable == 0
		return 
	elseif filename == ""
		exec a:cmd '.'
	elseif expand('%') =~# '^$\|^term:[\/][\/]'	
		exec a:cmd '.'
	else
		exec a:cmd '%:p:h'
		call s:seek(filename)
	endif
endfunc


command! -nargs=1 VinegarOpen call s:open(<f-args>)



"----------------------------------------------------------------------
" initialize
"----------------------------------------------------------------------
function! s:setup_vinegar()
endfunc


"----------------------------------------------------------------------
" events
"----------------------------------------------------------------------
augroup VinegarGroup
	autocmd!
	autocmd FileType netrw,nerdtree call s:setup_vinegar()
augroup END






