"----------------------------------------------------------------------
" check vundle existance
"----------------------------------------------------------------------
if !filereadable(expand('~/.vim/bundle/Vundle.vim/autoload/vundle.vim'))
	finish
endif


"----------------------------------------------------------------------
" check os
"----------------------------------------------------------------------
if has('win32') || has('win64') || has('win95') || has('win16')
	let s:uname = 'windows'
elseif has('unix')
	let s:uname = system("echo -n \"$(uname)\"")
	if !v:shell_error && s:uname == "Linux"
		let s:uname = 'linux'
	else
		let s:uname = 'darwin'
	endif
else
	let s:uname = 'posix'
endif


"----------------------------------------------------------------------
" Bundle Header
"----------------------------------------------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'


"----------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-fugitive'
"Plugin 'fs111/pydoc.vim'
"Plugin 'mattn/webapi-vim'
"Plugin 'mattn/gist-vim'
Plugin 'lambdalisue/vim-gista'
Plugin 'mhinz/vim-startify'
Plugin 'easymotion/vim-easymotion'


"----------------------------------------------------------------------
" Platforms
"----------------------------------------------------------------------
if has('win32') || has('win16') || has('win95') || has('win64')

elseif s:uname == 'linux'

elseif s:uname == 'darwin'

else

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

let g:startify_disable_at_vimenter = 1
let g:startify_session_dir = '~/.vim/session'


"----------------------------------------------------------------------
" keymaps
"----------------------------------------------------------------------
noremap <space>ht :Startify<cr>



