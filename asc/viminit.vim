" viminit.vim - Vim initialize script
"
" Maintainer: skywind3000 (at) gmail.com
" Last change: 2016.4.6
"
" Tiny script which makes vim become neat and handy, supports vim.tiny
"

" initialize basic settings
set nocompatible

set shiftwidth=4
set softtabstop=4
set noexpandtab
set tabstop=4
set cindent
set autoindent
set showtabline=1
set winaltkeys=no
set nohidden 
set nowrap
set wildignore=*.swp,*.bak,*.pyc,*.obj,*.o,*.class
set backspace=eol,start,indent
set cmdheight=1
set ruler
set nopaste

if has('multi_byte')
	set fileencodings=utf-8,gb2312,gbk,gb18030,big5
	set fenc=utf-8
	set enc=utf-8
endif

if has('syntax')  
	syntax enable 
	syntax on 
endif

if has('autocmd') 
	filetype plugin indent on 
endif

if has('mouse')
	set mouse=c
endif

"set nobackup
"set nowritebackup
"set noswapfile


" map CTRL_HJKL to move cursor in all mode
noremap <C-h> <left>
noremap <C-j> <down>
noremap <C-k> <up>
noremap <C-l> <right>
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>


" use hotkey to change buffer
noremap <silent><leader>bn :bn<cr>
noremap <silent><leader>bp :bp<cr>
noremap <silent><leader>bm :bm<cr>
noremap <silent><leader>bv :vs<cr>
noremap <silent><leader>bd :bdelete<cr>
noremap <silent><leader>bl :ls<cr>
noremap <silent><leader>nh :nohl<cr>

" use hotkey to operate tab
noremap <silent><tab>m :tabnew<cr>
noremap <silent><tab>e :tabclose<cr>
noremap <silent><tab>n :tabn<cr>
noremap <silent><tab>p :tabp<cr>
noremap <silent><leader>t :tabnew<cr>
noremap <silent><leader>g :tabclose<cr>
noremap <silent><leader>1 :tabn 1<cr>
noremap <silent><leader>2 :tabn 2<cr>
noremap <silent><leader>3 :tabn 3<cr>
noremap <silent><leader>4 :tabn 4<cr>
noremap <silent><leader>5 :tabn 5<cr>
noremap <silent><leader>6 :tabn 6<cr>
noremap <silent><leader>7 :tabn 7<cr>
noremap <silent><leader>8 :tabn 8<cr>
noremap <silent><leader>9 :tabn 9<cr>
noremap <silent><leader>0 :tabn 10<cr>
noremap <silent><s-tab> :tabnext<CR>
inoremap <silent><s-tab> <ESC>:tabnext<CR>


" Alt+N to switch table quickly in windows
if has('gui_running') && (has("win32") || has("win64"))
	noremap <silent><c-tab> :tabprev<CR>
	inoremap <silent><c-tab> <ESC>:tabprev<CR>
	noremap <silent><m-1> :tabn 1<cr>
	noremap <silent><m-2> :tabn 2<cr>
	noremap <silent><m-3> :tabn 3<cr>
	noremap <silent><m-4> :tabn 4<cr>
	noremap <silent><m-5> :tabn 5<cr>
	noremap <silent><m-6> :tabn 6<cr>
	noremap <silent><m-7> :tabn 7<cr>
	noremap <silent><m-8> :tabn 8<cr>
	noremap <silent><m-9> :tabn 9<cr>
	noremap <silent><m-0> :tabn 10<cr>
	inoremap <silent><m-1> <ESC>:tabn 1<cr>
	inoremap <silent><m-2> <ESC>:tabn 2<cr>
	inoremap <silent><m-3> <ESC>:tabn 3<cr>
	inoremap <silent><m-4> <ESC>:tabn 4<cr>
	inoremap <silent><m-5> <ESC>:tabn 5<cr>
	inoremap <silent><m-6> <ESC>:tabn 6<cr>
	inoremap <silent><m-7> <ESC>:tabn 7<cr>
	inoremap <silent><m-8> <ESC>:tabn 8<cr>
	inoremap <silent><m-9> <ESC>:tabn 9<cr>
	inoremap <silent><m-0> <ESC>:tabn 10<cr>
endif

" cmd+N to switch table quickly in macvim
if has("gui_macvim")
	set macmeta
	noremap <silent><c-tab> :tabprev<CR>
	inoremap <silent><c-tab> <ESC>:tabprev<CR>
	noremap <silent><d-1> :tabn 1<cr>
	noremap <silent><d-2> :tabn 2<cr>
	noremap <silent><d-3> :tabn 3<cr>
	noremap <silent><d-4> :tabn 4<cr>
	noremap <silent><d-5> :tabn 5<cr>
	noremap <silent><d-6> :tabn 6<cr>
	noremap <silent><d-7> :tabn 7<cr>
	noremap <silent><d-8> :tabn 8<cr>
	noremap <silent><d-9> :tabn 9<cr>
	noremap <silent><d-0> :tabn 10<cr>
	inoremap <silent><d-1> <ESC>:tabn 1<cr>
	inoremap <silent><d-2> <ESC>:tabn 2<cr>
	inoremap <silent><d-3> <ESC>:tabn 3<cr>
	inoremap <silent><d-4> <ESC>:tabn 4<cr>
	inoremap <silent><d-5> <ESC>:tabn 5<cr>
	inoremap <silent><d-6> <ESC>:tabn 6<cr>
	inoremap <silent><d-7> <ESC>:tabn 7<cr>
	inoremap <silent><d-8> <ESC>:tabn 8<cr>
	inoremap <silent><d-9> <ESC>:tabn 9<cr>
	inoremap <silent><d-0> <ESC>:tabn 10<cr>
	noremap <silent><d-o> :browse tabnew<cr>
	inoremap <silent><d-o> <ESC>:browse tabnew<cr>
endif

" fast file/tab actions in gui
if has('gui_running')
	noremap <silent><m-o> :tabnew<cr>
	inoremap <silent><m-o> <ESC>:tabnew<cr>
	noremap <silent><m-t> :tabnew<cr>
	inoremap <silent><m-t> <ESC>:tabnew<cr>
	noremap <silent><m-w> :tabclose<cr>
	inoremap <silent><m-w> <ESC>:tabclose<cr>
	noremap <m-s> :w<cr>
	inoremap <m-s> <esc>:w<cr>
endif

" miscs
set scrolloff=3
set laststatus=1
set showmatch
set display=lastline
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<
set matchtime=3

" leader definition
noremap <silent><leader>w :w<cr>
noremap <silent><leader>q :q<cr>
noremap <silent><leader>l :close<cr>

" window management
noremap <tab>h <c-w>h
noremap <tab>j <c-w>j
noremap <tab>k <c-w>k
noremap <tab>l <c-w>l
noremap <tab>w <c-w>w

" ctrl-enter to insert a empty line below, shift-enter to insert above
noremap <tab>o o<ESC>
noremap <tab>O O<ESC>

" faster insert mode
inoremap <c-x> <del>
inoremap <c-c> <bs>
inoremap <c-\> <c-k>

" as emacs
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-d> <del>
vnoremap <c-c> "+y

" faster command mode
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <c-p> <up>
cnoremap <c-n> <down>
cnoremap <c-d> <del>
cnoremap <c-x> <del>
cnoremap <c-c> <bs>



