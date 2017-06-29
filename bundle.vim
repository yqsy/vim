"----------------------------------------------------------------------
" check vundle existance
"----------------------------------------------------------------------
if !filereadable(expand('~/.vim/bundle/Vundle.vim/autoload/vundle.vim'))
	echom "cannot find vundle in ~/.vim/bundle/Vundle.vim"
	finish
endif


"----------------------------------------------------------------------
" bundle group
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = []
endif

let s:bundle_all = 0

if index(g:bundle_group, 'all') >= 0 
	let s:bundle_all = 1
endif


"----------------------------------------------------------------------
" check os
"----------------------------------------------------------------------
if has('win32') || has('win64') || has('win95') || has('win16')
	let s:uname = 'windows'
	let g:bundle_group += ['windows']
elseif has('win32unix')
	let s:uname = 'cygwin'
elseif has('unix')
	let s:uname = system("echo -n \"$(uname)\"")
	if !v:shell_error && s:uname == "Linux"
		let s:uname = 'linux'
		let g:bundle_group += ['linux']
	else
		let s:uname = 'darwin'
		let g:bundle_group += ['darwin']
	endif
else
	let s:uname = 'posix'
	let g:bundle_group += ['posix']
endif



"----------------------------------------------------------------------
" Bundle Header
"----------------------------------------------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'


"----------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------
"Plugin 'SirVer/ultisnips'
"Plugin 'honza/vim-snippets'
"Plugin 'tpope/vim-fugitive'
"Plugin 'fs111/pydoc.vim'
"Plugin 'mattn/webapi-vim'
"Plugin 'mattn/gist-vim'
"Plugin 'lambdalisue/vim-gista'
"Plugin 'mhinz/vim-startify'
"Plugin 'easymotion/vim-easymotion'


"----------------------------------------------------------------------
" Group - simple
"----------------------------------------------------------------------
if index(g:bundle_group, 'simple') >= 0 || s:bundle_all
	" Plugin 'scrooloose/nerdtree'
	Plugin 'vim-scripts/Colour-Sampler-Pack'
endif


"----------------------------------------------------------------------
" Group - basic
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0 || s:bundle_all
	Plugin 'honza/vim-snippets'
	Plugin 'tpope/vim-fugitive'
	Plugin 'lambdalisue/vim-gista'
	Plugin 'mhinz/vim-startify'
	Plugin 'easymotion/vim-easymotion'
	Plugin 'ctrlpvim/ctrlp.vim'
	Plugin 'KabbAmine/zeavim.vim'
	Plugin 'lifepillar/vim-solarized8'
	Plugin 'godlygeek/tabular'
	"Plugin 'sheerun/vim-polyglot'


	if !has('gui_running')
		if $SSH_CONNECTION != "" || $TERM_PROGRAM == 'iTerm.app'
			exec "set <m-i>=\e]{0}i~"
			exec "set <m-j>=\e]{0}j~"
			exec "set <m-k>=\e]{0}k~"
			exec "set <m-l>=\e]{0}l~"
		elseif has('win32unix')
			exec "set <m-i>=\ei"
			exec "set <m-j>=\ej"
			exec "set <m-k>=\ek"
			exec "set <m-l>=\el"  
		endif
	endif

	"let g:gitgutter_enabled = 0

	let g:zv_file_types = {
				\ "^c$" : 'cpp,c',
				\ "^cpp$" : 'cpp,c',
				\ "python": 'python',
				\ "vim": 'vim'
				\ }

	noremap <space>ht :Startify<cr>
	noremap <space>hy :tabnew<cr>:Startify<cr> 
endif


"----------------------------------------------------------------------
" Group - inter
"----------------------------------------------------------------------
if index(g:bundle_group, 'inter') >= 0 || s:bundle_all
	Plugin 'vim-scripts/DrawIt'
	Plugin 'mbbill/VimExplorer'
	Plugin 'rust-lang/rust.vim'
	Plugin 'vim-scripts/CRefVim'
	Plugin 'vim-scripts/stlrefvim'
	Plugin 'skywind3000/vimoutliner'
				
	if has('python')
		Plugin 'skywind3000/vimpress'
		"Plugin 'SirVer/ultisnips'
	endif

	noremap <space>bp :BlogPreview local<cr>
	noremap <space>bb :BlogPreview publish<cr>
	noremap <space>bs :BlogSave<cr>
	noremap <space>bd :BlogSave draft<cr>
	noremap <space>bn :BlogNew post<cr>
	noremap <space>bl :BlogList<cr>

	map <silent> <leader>ck <Plug>CRV_CRefVimAsk
	map <silent> <leader>cj <Plug>CRV_CRefVimInvoke

	vmap <silent> <leader>sr <Plug>StlRefVimVisual
	map <silent> <leader>sr <Plug>StlRefVimNormal
	map <silent> <leader>sw <Plug>StlRefVimAsk
	map <silent> <leader>sc <Plug>StlRefVimInvoke
	map <silent> <leader>se <Plug>StlRefVimExample
endif



"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
if index(g:bundle_group, 'opt') >= 0
	Plugin 'thinca/vim-quickrun'
	if has('python')
		"Plugin 'mgedmin/pythonhelper.vim'
		"Plugin 'mgedmin/chelper.vim'
	endif
	"Plugin 'vim-scripts/svn-diff.vim'
	"Plugin 'airblade/vim-gitguttr'
	"let g:gitgutter_enabled = 1
	"let g:gitgutter_sign_column_always = 1
endif


"----------------------------------------------------------------------
" Group - jedi
"----------------------------------------------------------------------
if index(g:bundle_group, 'jedi') >= 0
	Plugin 'davidhalter/jedi-vim'
endif


"----------------------------------------------------------------------
" Group - neocomplete
"----------------------------------------------------------------------
if index(g:bundle_group, 'neocomplete') >= 0
	if has('lua')
		Plugin 'Shougo/neocomplete.vim'
	endif
	set completeopt=longest,menuone
	"inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<tab>"
	"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
	let g:neocomplete#enable_at_startup = 1 
endif


"----------------------------------------------------------------------
" Group - ymc
"----------------------------------------------------------------------
if index(g:bundle_group, 'ymc') >= 0
endif


"----------------------------------------------------------------------
" Group - special
"----------------------------------------------------------------------
if index(g:bundle_group, 'special') >= 0
	Plugin 'kshenoy/vim-signature'
	"Plugin 'scrooloose/syntastic'
	"Plugin 'tpope/vim-dispatch'
	"Plugin 'bling/vim-airline'
	Plugin 'mh21/errormarker.vim'
	Plugin 'dracula/vim'

	if s:uname != 'windows2'
		" this plugin is too slow, 3 seconds delay for open a new file
		Plugin 'mhinz/vim-signify'
	endif

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 0
	let g:syntastic_check_on_open = 0
	let g:syntastic_check_on_wq = 0

	let g:airline_left_sep = ''
	let g:airline_left_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_sep = ''

	let g:errormarker_disablemappings = 1
	nnoremap <silent> <leader>cm :ErrorAtCursor<CR>
	nnoremap <silent> <leader>cM :RemoveErrorMarkers<cr>

	"let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
endif



"----------------------------------------------------------------------
" experiment
"----------------------------------------------------------------------
if index(g:bundle_group, 'experiment') >= 0
	Plugin 'mattn/vim-terminal'
	Plugin 'Shougo/vimshell.vim'
	Plugin 'Shougo/vimproc.vim'
	" Plugin 'w0rp/ale'
endif


"----------------------------------------------------------------------
" completor
"----------------------------------------------------------------------
if index(g:bundle_group, 'completor') >= 0
	Plugin 'maralla/completor.vim'
endif


"----------------------------------------------------------------------
" Group - windows
"----------------------------------------------------------------------
if index(g:bundle_group, 'windows') >= 0
endif


"----------------------------------------------------------------------
" Group - linux
"----------------------------------------------------------------------
if index(g:bundle_group, 'linux') >= 0
endif


"----------------------------------------------------------------------
" Group - posix
"----------------------------------------------------------------------
if index(g:bundle_group, 'posix') >= 0
endif


"----------------------------------------------------------------------
" Bundle Footer
"----------------------------------------------------------------------
call vundle#end()
filetype on


"----------------------------------------------------------------------
" Settings
"----------------------------------------------------------------------
let g:pydoc_cmd = 'python -m pydoc'
let g:gist_use_password_in_gitconfig = 1

if !exists('g:startify_disable_at_vimenter')
	let g:startify_disable_at_vimenter = 1
endif

let g:startify_session_dir = '~/.vim/session'


"----------------------------------------------------------------------
" keymaps
"----------------------------------------------------------------------



