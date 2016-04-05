set nocompatible
syntax enable
syntax on

set shiftwidth=4
set tabstop=4
set cindent
set autoindent
set fileencodings=utf-8,gb2312,gbk,gb18030,big5
set fenc=utf-8
set enc=utf-8
set showtabline=1
set mouse=c
set winaltkeys=no
set hidden
set nowrap
set wildignore=*.swp,*.bak,*.pyc,*.obj,*.o,*.class
set backspace=eol,start,indent
set cmdheight=1
set ruler
set nopaste

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
noremap <silent><F1> :bp<CR>
noremap <silent><F2> :bn<CR>
inoremap <silent><F1> <C-o>:bp<CR>
inoremap <silent><F2> <C-o>:bn<CR>
noremap <silent><tab>n :bn<cr>
noremap <silent><tab>p :bp<cr>
noremap <silent><tab>m :bm<cr>
noremap <silent><tab>v :vs<cr>
noremap <silent><tab>c :nohl<cr>

" use hotkey to operate tab
noremap <silent><leader>t :tabnew<cr>
noremap <silent><leader>g :tabclose<cr>
noremap <silent><F3> :tabp<cr>
noremap <silent><F4> :tabn<cr>
inoremap <silent><F3> <ESC>:tabp<cr>
inoremap <silent><F4> <ESC>:tabn<cr>
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

" cmd+N to switch table quickly in macvim
if has("gui_macvim")
	noremap <silent><s-tab> :tabnext<CR>
	noremap <silent><c-tab> :tabprev<CR>
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
	inoremap <silent><s-tab> <ESC>:tabnext<CR>
	inoremap <silent><c-tab> <ESC>:tabprev<CR>
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
noremap <silent><leader>d :bp\|bd #<CR>

" window management
noremap <tab>h <c-w>h
noremap <tab>j <c-w>j
noremap <tab>k <c-w>k
noremap <tab>l <c-w>l
noremap <tab>w <c-w>w

" set number
let s:need_number = 0

function! ToggleNumberView()
	if s:need_number == 0
		set number
		let s:need_number = 1
	else
		set nonumber
		let s:need_number = 0
	endif
endfunc

noremap <silent><leader>n :call ToggleNumberView()<cr>

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

" delete buffer keep window
function! s:BufferClose(bang, buffer)
	let l:bufcount = bufnr('$')
	let l:switch = 0 	" window which contains target buffer will be switched
	if empty(a:buffer)
		let l:target = bufnr('%')
	elseif a:buffer =~ '^\d\+$'
		let l:target = bufnr(str2nr(a:buffer))
	else
		let l:target = bufnr(a:buffer)
	endif
	if l:target <= 0
		echohl ErrorMsg
		echomsg "cannot find buffer: '" . a:buffer . "'"
		echohl NONE
		return 0
	endif
	if !getbufvar(l:target, "&modifiable")
		echohl ErrorMsg
		echomsg "Cannot close a non-modifiable buffer"
		echohl NONE
		return 0
	endif
	if empty(a:bang) && getbufvar(l:target, '&modified')
		echohl ErrorMsg
		echomsg "No write since last change (use :BufferClose!)"
		echohl NONE
		return 0
	endif
	if bufnr('#') > 0	" check alternative buffer
		let l:aid = bufnr('#')
		if l:aid != l:target && buflisted(l:aid) && getbufvar(l:aid, "&modifiable")
			let l:switch = l:aid	" switch to alternative buffer
		endif
	endif
	if l:switch == 0	" check non-scratch buffers
		let l:index = l:bufcount
		while l:index >= 0
			if buflisted(l:index) && getbufvar(l:index, "&modifiable")
				if strlen(bufname(l:index)) > 0 && l:index != l:target
					let l:switch = l:index	" switch to that buffer
					break
				endif
			endif
			let l:index = l:index - 1	
		endwhile
	endif
	if l:switch == 0	" check scratch buffers
		let l:index = l:bufcount
		while l:index >= 0
			if buflisted(l:index) && getbufvar(l:index, "&modifiable")
				if l:index != l:target
					let l:switch = l:index	" switch to a scratch
					break
				endif
			endif
			let l:index = l:index - 1
		endwhile
	endif
	if l:switch  == 0	" check if only one scratch left
		if strlen(bufname(l:target)) == 0 && (!getbufvar(l:target, "&modified"))
			echo "This is the last scratch" 
			return 0
		endif
	endif
	let l:ntabs = tabpagenr('$')
	let l:tabcc = tabpagenr()
	let l:wincc = winnr()
	let l:index = 1
	while l:index <= l:ntabs
		exec 'tabn '.l:index
		while 1
			let l:wid = bufwinnr(l:target)
			if l:wid <= 0 | break | endif
			exec l:wid.'wincmd w'
			if l:switch == 0
				exec 'enew!'
				let l:switch = bufnr('%')
			else
				exec 'buffer '.l:switch
			endif
		endwhile
		let l:index += 1
	endwhile
	exec 'tabn ' . l:tabcc
	exec l:wincc . 'wincmd w'
	exec 'bdelete! '.l:target
	return 1
endfunction

command! -bang -nargs=? BufferClose call s:BufferClose('<bang>', '<args>')

noremap <silent><leader>e :BufferClose<cr>



