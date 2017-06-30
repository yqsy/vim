"======================================================================
"
" vinegar2.vim - Vinegar & Oil (my own version)
"
" Created by skywind on 2017/06/30
" Last change: 2017/06/30 13:33:48
"
" Split windows and the project drawer go together like oil and 
" vinegar. I don't mean to say that you can combine them to create a 
" delicious salad dressing. I mean that they don't mix well!
"    --   Drew Neil
"
"======================================================================

let s:netrw_up = ''
let s:windows = has('win32') || has('win64') || has('win16') || has('win95')

if !exists('g:vinegar_key')
	let g:vinegar_key = '+'
endif

function! s:log(text)
	call LogWrite(a:text)
endfunc


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
	if (&buftype == "nofile" || &buftype == "quickfix") && &ft != 'nerdtree'
		return
	elseif &filetype ==# 'netrw'
		if s:netrw_up == ''
			return
		endif
		let currdir = fnamemodify(b:netrw_curdir, ':t')
		let nextdir = fnamemodify(b:netrw_curdir, ':h:p')
		if s:windows && strlen(nextdir) == 3 
			let t = strpart(nextdir, 1, 2)
			if t == ':/' || t == ":\\"
				let t = nextdir . '.'
				if tolower(nextdir) != tolower(b:netrw_curdir)
					execute a:cmd t
					call s:seek(currdir)
				endif
				return
			endif
		endif
		exec s:netrw_up
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
	let key = g:vinegar_key
	call s:log('setup: ' . &ft)
	if &ft == 'netrw'
		if s:netrw_up == ''
			let s:netrw_up = substitute(maparg('-', 'n'), '\c^:\%(<c-u>\)\=', '', '')
			let s:netrw_up = strpart(s:netrw_up, 0, strlen(s:netrw_up)-4)
		endif
		nnoremap <buffer> - :VinegarOpen edit<cr>
		if key != '-'
			exec 'nnoremap <buffer> ' . key. ' :VinegarOpen edit<cr>'
		endif
	elseif &ft == 'nerdtree'
		nmap <buffer> - :VinegarOpen edit<cr>
		if key != '-'
			exec 'nmap <buffer> ' . key. ' :VinegarOpen edit<cr>'
		endif
	endif
endfunc


"----------------------------------------------------------------------
" events
"----------------------------------------------------------------------
augroup VinegarGroup
	autocmd!
	autocmd FileType netrw call s:setup_vinegar()
	autocmd FileType nerdtree call s:setup_vinegar()
augroup END






