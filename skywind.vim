"----------------------------------------------------------------------
"- Global Settings
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let &tags .= ',.tags,' . expand('~/.vim/tags/standard.tags')

filetype plugin indent on
set hlsearch

if !has('gui_running')
	set ttimeoutlen=100
endif

command! -nargs=1 VimImport exec 'so '.s:home.'/'.'<args>'
command! -nargs=1 VimLoad exec 'set rtp+='.s:home.'/'.'<args>'


highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE 
	\ gui=NONE guifg=DarkGrey guibg=NONE

call Backup_Directory()


"----------------------------------------------------------------------
"- Autocmds
"----------------------------------------------------------------------
au BufNewFile,BufRead *.as setlocal filetype=actionscript
au FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
" au FileType c,cpp set foldmethod=syntax 
" au FileType python set foldmethod=syntax 


"----------------------------------------------------------------------
"- Return last position
"----------------------------------------------------------------------
autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\	 exe "normal! g`\"" |
	\ endif



"----------------------------------------------------------------------
"- Vimmake
"----------------------------------------------------------------------
let g:vimmake_cwd = 1
let g:vimmake_run_guess = ['go']
let g:vimmake_build_scroll = 3

if has('win32') || has('win64') || has('win16') || has('win95')
	let g:vimmake_cflags = ['-O3', '-lwinmm', '-lstdc++', '-lgdi32', '-lws2_32', '-msse3']
else
	let g:vimmake_cflags = ['-O3', '-lstdc++']
	runtime ftplugin/man.vim
endif


"----------------------------------------------------------------------
"- OptImport
"----------------------------------------------------------------------
VimImport site/echofunc.vim
VimImport site/calendar.vim

let g:EchoFuncBallonOnly = 1


"----------------------------------------------------------------------
"- OmniCpp
"----------------------------------------------------------------------
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1 
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_MayCompleteDot = 1  
let OmniCpp_MayCompleteArrow = 1 
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]


"----------------------------------------------------------------------
"- Terminal Keymaps
"----------------------------------------------------------------------
function! TerminalKeyInit(term)
	if has('gui_running')
		return
	endif
	if a:term == 0
		exec "set <m-i>=\e]{0}i~"
		exec "set <m-j>=\e]{0}j~"
		exec "set <m-k>=\e]{0}k~"
		exec "set <m-l>=\e]{0}l~"
	else
		exec "set <m-i>=\ei"
		exec "set <m-j>=\ej"
		exec "set <m-k>=\ek"
		exec "set <m-l>=\el"
	endif
endfunc



"----------------------------------------------------------------------
"- neocomplete
"----------------------------------------------------------------------
if 0
	let g:acp_enableAtStartup = 0
	" Use neocomplete.
	let g:neocomplete#enable_at_startup = 1
	" Use smartcase.
	let g:neocomplete#enable_smart_case = 1
	" Set minimum syntax keyword length.
	let g:neocomplete#sources#syntax#min_keyword_length = 3
	let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

	" Define dictionary.
	let g:neocomplete#sources#dictionary#dictionaries = {
				\ 'default' : '',
				\ 'vimshell' : $HOME.'/.vimshell_hist',
				\ 'scheme' : $HOME.'/.gosh_completions'
				\ }

	" Define keyword.
	if !exists('g:neocomplete#keyword_patterns')
		let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns['default'] = '\h\w*'

	" Plugin key-mappings.
	inoremap <expr><C-g>     neocomplete#undo_completion()
	"inoremap <expr><C-l>     neocomplete#complete_common_string()

	" Recommended key-mappings.
	" <CR>: close popup and save indent.
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	function! s:my_cr_function()
		return neocomplete#close_popup() . "\<CR>"
		" For no inserting <CR> key.
		"return pumvisible() ? neocomplete#close_popup() : "\<CR>"
	endfunction
	" <TAB>: completion.
	inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
	" <C-h>, <BS>: close popup and delete backword char.
	"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><C-y>  neocomplete#close_popup()
	inoremap <expr><C-e>  neocomplete#cancel_popup()
	" Close popup by <Space>.
	inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

	" AutoComplPop like behavior.
	let g:neocomplete#enable_auto_select = 1

	" Shell like behavior(not recommended).
	set completeopt+=longest
	let g:neocomplete#enable_auto_select = 1
	let g:neocomplete#disable_auto_complete = 1
	inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

	" Enable omni completion.
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

	" Enable heavy omni completion.
	if !exists('g:neocomplete#sources#omni#input_patterns')
		let g:neocomplete#sources#omni#input_patterns = {}
	endif

	"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
	"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
	"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

	" For perlomni.vim setting.
	" https://github.com/c9s/perlomni.vim
	let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
endif

"----------------------------------------------------------------------
"- netrw / winmanager
"----------------------------------------------------------------------
let s:enter = 0

let g:bufExplorerWidth=26
let g:winManagerWindowLayout = "FileExplorer|TagList"
"let g:winManagerWindowLayout = "FileExplorer|Tagbar"
let g:winManagerWidth=26

"let g:bufferhint_KeepWindow = 1
set completeopt=menu

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


"----------------------------------------------------------------------
"- ToggleDevelop
"----------------------------------------------------------------------
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
noremap <leader>fc :Calendar<cr>
noremap <leader>ft :NERDTree<cr>:vertical resize +3<cr>


"----------------------------------------------------------------------
"- bufferhint
"----------------------------------------------------------------------
nnoremap - :call bufferhint#Popup()<CR>
nnoremap <leader>p :call bufferhint#LoadPrevious()<CR>



"----------------------------------------------------------------------
" Enable vim-diff-enhanced (Christian Brabandt)
"----------------------------------------------------------------------
function! EnableEnhancedDiff()
	let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endfunc



