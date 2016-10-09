"----------------------------------------------------------------------
" check vundle existance
"----------------------------------------------------------------------
if !filereadable(expand('~/.vim/bundle/Vundle.vim/autoload/vundle.vim'))
	finish
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

if has('win32') || has('win64') || has('win95') || has('win16')
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



