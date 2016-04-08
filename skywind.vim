let &tags .= ',.tags,' . expand('~/.vim/tags/standard.tags')

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

noremap <silent><leader>bl :ls<cr>

let s:enter = 0
let g:netrw_winsize = 25
let g:netrw_list_hide= '.*\.swp$,.*\.pyc,*\.o,*\.bak,\.git,\.svn'

let g:bufExplorerWidth=26
let g:winManagerWindowLayout = "FileExplorer|TagList"
"let g:winManagerWindowLayout = "FileExplorer|Tagbar"
let g:winManagerWidth=26

"let g:bufferhint_KeepWindow = 1
set completeopt=menu

let g:Tagbar_title = "[Tagbar]"
let g:tagbar_vertical = 28
" let g:tagbar_left = 1
function! Tagbar_Start()
    exe 'TagbarOpen'
    exe 'q' 
endfunction
 
function! Tagbar_IsValid()
    return 1
endfunction

function! WMResize()
	FirstExplorerWindow
	vertical resize 28
	set winfixwidth
	wincmd l
endfunc

function! WMFocusEdit(n)
	FirstExplorerWindow
	wincmd l
	if a:n > 0
		wincmd l
	endif
endfunc

function! WMFocusQuickfix()
	exec "FirstExplorerWindow"
	exec "wincmd l"
	exec "wincmd j"
endfunc

function! s:TbInit()
	if !filereadable(expand('~/.vim/tabbar2.vim'))
		return 0
	endif
	source ~/.vim/tabbar2.vim
	exec 'TbStart'
	exec 'wincmd j'
	return 1
endfunc

function! ToggleDevelop(layout)
	if s:enter == 0
		"set showtabline=2
		set equalalways
		let s:enter = 1
	endif
	set equalalways
	if a:layout == 0
		set nonumber
		exec 'copen 6'
		wincmd j
		set winfixheight
		wincmd k
		exec 'wincmd l'
		exec 'WMToggle'
		exec 'wincmd l'
		let s:screenw = &columns
		let s:screenh = &lines
		let s:size = (s:screenw - 28) / 2
		exec 'set number'
		call WMResize()
		if s:size >= 65
			exec 'vs'
			exec 'wincmd h'
			exec 'wincmd h'
			exec 'vertical resize 28'
			set winfixwidth
			exec 'wincmd l'
			exec 'vertical resize ' . s:size
		endif
		"let s:enter = 1
	elseif a:layout == 1 || a:layout == 2
		set nonumber
		exec 'copen 6'
		wincmd j
		set winfixheight
		wincmd k
		exec 'wincmd l'
		exec 'WMToggle'
		exec 'wincmd l'
		exec 'TagbarOpen'
		call WMResize()
		exec 'wincmd l'
		exec 'wincmd l'
		exec 'vertical resize 28'
		set winfixwidth
		exec 'wincmd h'
		set number
		let s:size = (&columns - 58)
		exec 'vertical resize ' . s:size
		if a:layout == 2
			if s:TbInit()
				set showtabline=1
			endif
		endif
	elseif a:layout == 3 || a:layout == 4
		set nonumber
		copen 6
		wincmd j
		set winfixheight
		wincmd k
		TagbarOpen
		wincmd l
		vertical resize 28
		wincmd h
		set number
		if a:layout == 4
			vs
			wincmd h
			set winfixwidth
		endif
	endif
	highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
endfunc


noremap <leader>f1 :FirstExplorerWindow<cr>
noremap <leader>f2 :BottomExplorerWindow<cr>
noremap <leader>f3 :call WMFocusEdit(0)<cr>
noremap <leader>f4 :call WMFocusEdit(1)<cr>
noremap <leader>f0 :call WMFocusQuickfix()<cr>
noremap <leader>fm :call ToggleDevelop(0)<cr>
noremap <leader>fn :call ToggleDevelop(1)<cr>
noremap <leader>fs :call ToggleDevelop(3)<cr>
noremap <leader>fd :call ToggleDevelop(4)<cr>
noremap <leader>fb :call ToggleDevelop(2)<cr>
noremap <leader>fa :TagbarOpen<cr>

if 0
	noremap ¡ :tabn1<cr>
	noremap ™ :tabn2<cr>
	noremap £ :tabn3<cr>
	noremap ¢ :tabn4<cr>
	noremap ∞ :tabn5<cr>
	noremap § :tabn6<cr>
	inoremap ¡ <esc>:tabn1<cr>
	inoremap ™ <esc>:tabn2<cr>
	inoremap £ <esc>:tabn3<cr>
	inoremap ¢ <esc>:tabn4<cr>
	inoremap ∞ <esc>:tabn5<cr>
	inoremap § <esc>:tabn6<cr>
endif

let g:skywind_name = 'skywind3000 (at) google.com'
function! CopyrightSource()
	let l:filename = expand("%:t")
	let l:comment = '//'
	while strlen(l:comment) < 72
		let l:comment .= '='
	endwhile
	call append(line(".") - 1, l:comment)
	call append(line(".") - 1, '//')
	call append(line(".") - 1, '// '. l:filename . ' - '.g:skywind_name)
	call append(line(".") - 1, '// ')
	call append(line(".") - 1, '// NOTE:')
	call append(line(".") - 1, '// This file is created by skywind in '. strftime("%c"))
	call append(line(".") - 1, '// For more information, please see the readme file.')
	call append(line(".") - 1, '//')
	call append(line(".") - 1, l:comment)
endfunc



nnoremap - :call bufferhint#Popup()<CR>
nnoremap <leader>p :call bufferhint#LoadPrevious()<CR>


