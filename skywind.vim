"----------------------------------------------------------------------
"- Global Settings
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let &tags = './.tags;,.tags,' . expand('~/.vim/tags/standard.tags')

filetype plugin indent on
set hlsearch
set incsearch
set wildmenu
set cpo-=<
set wcm=<C-Z>
noremap <tab>/ :emenu <C-Z>
" noremap <c-n>  :emenu <C-Z>
set lazyredraw
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m

command! -nargs=1 VimImport exec 'so '.s:home.'/'.'<args>'
command! -nargs=1 VimLoad exec 'set rtp+='.s:home.'/'.'<args>'


highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE 
	\ gui=NONE guifg=DarkGrey guibg=NONE

call Backup_Directory()

let g:ycm_goto_buffer_command = 'new-or-existing-tab'

if has('patch-7.4.500') || v:version >= 800
	if !has('nvim')
		set cryptmethod=blowfish2
	endif
endif


"----------------------------------------------------------------------
"- Autocmds
"----------------------------------------------------------------------
augroup SkywindGroup
	au!
	au User AsyncRunStart call asyncrun#quickfix_toggle(6, 1)
	au User VimMakeStart call vimmake#toggle_quickfix(6, 1)
	au User VimScope call vimmake#toggle_quickfix(6, 1)
	au BufNewFile,BufRead *.as setlocal filetype=actionscript
	au BufNewFile,BufRead *.pro setlocal filetype=prolog
	au BufNewFile,BufRead *.es setlocal filetype=erlang
	au BufNewFile,BufRead *.asc setlocal filetype=asciidoc
	au FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
	au FileType lisp setlocal ts=8 sts=2 sw=2 et
	au FileType scala setlocal sts=4 sw=4 noet
	au FileType haskell setlocal et
augroup END


"----------------------------------------------------------------------
" keymaps 
"----------------------------------------------------------------------
if has('win32') || has('win16') || has('win64') || has('win95')
	noremap <space>hw :FileSwitch tabe e:/svn/doc/linwei/GTD.otl<cr>
else
endif


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
let g:vimmake_run_guess = ['go']
let g:vimmake_extrun = {'hs': 'runghc', 'lisp': 'sbcl --script'}

let g:vimmake_extrun['scala'] = 'scala'
let g:vimmake_extrun['es'] = 'escript'
let g:vimmake_extrun['erl'] = 'escript'
let g:vimmake_extrun['clj'] = 'clojure'
let g:vimmake_extrun['hs'] = 'runghc'

if has('win32') || has('win64') || has('win16') || has('win95')
	let g:vimmake_extrun['scm'] = "d:\\linux\\bin\\guile.exe"
	let g:vimmake_extrun['io'] = "d:\\dev\\IoLanguage\\bin\\io.exe"
	let g:vimmake_extrun['pro'] = "start d:\\dev\\swipl\\bin\\swipl-win.exe -s"
	let g:vimmake_extrun['pl'] = "start d:\\dev\\swipl\\bin\\swipl-win.exe -s"
	let g:vimmake_build_encoding = 'gbk'
	let g:asyncrun_encs = 'gbk'
	let cp = "d:/dev/scala/scala-2.11.6/lib/scala-actors-2.11.0.jar;"
	let cp.= "d:/dev/scala/scala-2.11.6/lib/akka-actor_2.11-2.3.4.jar"
	let g:vimmake_extrun['scala'] = 'scala'
	"let g:vimmake_extrun['scala'].= ' -cp '.fnameescape(cp)
else
	if executable('clisp')
		let g:vimmake_extrun['lisp'] = 'clisp'
	elseif executable('sbcl')
		let g:vimmake_extrun['list'] = 'sbcl --script'
	endif
	if executable('swipl')
		let g:vimmake_extrun['pro'] = 'swipl -s'
	endif
endif

if has('win32') || has('win64') || has('win16') || has('win95')
	let g:vimmake_cflags = ['-O3', '-lwinmm', '-lstdc++', '-lgdi32', '-lws2_32', '-msse3']
else
	let g:vimmake_cflags = ['-O3', '-lstdc++']
	runtime ftplugin/man.vim
	nnoremap K :Man <cword><CR>
	let g:ft_man_open_mode = 'vert'
endif

if has('nvim')
	let g:asyncrun_trim = 1
	let g:vimmake_build_trim = 1
endif

let g:vimmake_mode = {}

for s:i in range(10)
	let g:vimmake_mode[s:i] = 'async'
	let g:vimmake_mode['c'.s:i] = 'async'
endfor


"----------------------------------------------------------------------
"- OptImport
"----------------------------------------------------------------------
VimImport site/echofunc.vim
VimImport site/calendar.vim
"VimImport site/hilinks.vim

if has('gui_running')
	VimImport site/hexhigh.vim
endif



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



command! -bang -nargs=* -complete=file Make VimMake -program=make @ <args>



"----------------------------------------------------------------------
" netrw syntax
"----------------------------------------------------------------------

" reset netrw's special
function! s:netrw_special()
	hi netrwCompress term=NONE cterm=NONE gui=NONE ctermfg=10 guifg=green  ctermbg=0 guibg=black
	hi netrwData	  term=NONE cterm=NONE gui=NONE ctermfg=9 guifg=blue ctermbg=0 guibg=black
	hi netrwHdr	  term=NONE cterm=NONE,italic gui=NONE guifg=SeaGreen1
	"hi! default link netrwHdr Float
	hi netrwLex	  term=NONE cterm=NONE,italic gui=NONE guifg=SeaGreen1
	hi netrwYacc	  term=NONE cterm=NONE,italic gui=NONE guifg=SeaGreen1
	hi netrwLib	  term=NONE cterm=NONE gui=NONE ctermfg=14 guifg=yellow
	hi netrwObj	  term=NONE cterm=NONE gui=NONE ctermfg=12 guifg=red
	hi netrwTilde	  term=NONE cterm=NONE gui=NONE ctermfg=12 guifg=red
	hi netrwTmp	  term=NONE cterm=NONE gui=NONE ctermfg=12 guifg=red
	hi netrwTags	  term=NONE cterm=NONE gui=NONE ctermfg=12 guifg=red
	hi netrwDoc	  term=NONE cterm=NONE gui=NONE ctermfg=220 ctermbg=27 guifg=yellow2 guibg=Blue3
	hi netrwSymLink  term=NONE cterm=NONE gui=NONE ctermfg=220 ctermbg=27 guifg=grey60
endfunc

function! s:netrw_highlight()
	if !exists('g:netrw_special_syntax') || g:netrw_special_syntax == 0
		return
	endif

	redir => x
	silent color
	redir END
	syn match netrwCpp	"\(\S\+ \)*\S\+\.\%(c\|cpp\|m\|cc\|mm\|cxx\)\>" contains=netrwTreeBar,@NoSpell
	syn match netrwSrc	"\(\S\+ \)*\S\+\.\%(py\|pyw\|java\|s\|asm\|vim\)\>" contains=netrwTreeBar,@NoSpell

	if x =~ 'seoul256xxxx'
		hi! default link netrwHdr Conditional
		hi! default link netrwCpp Repeat
	else
		let mode = 1
		if mode == 3 && &t_Co == 16 | let mode = 2 | endif
		if mode == 0
			hi netrwHdr term=NONE cterm=NONE gui=NONE ctermfg=7 guifg=#c0c0c0
			hi netrwCpp term=NONE cterm=NONE gui=NONE ctermfg=7 guifg=#c0c0c0
			hi netrwSrc term=NONE cterm=NONE gui=NONE ctermfg=7 guifg=#c0c0c0
		elseif mode == 1
			if &t_Co != 256
				hi netrwHdr term=NONE cterm=NONE gui=NONE ctermfg=15 guifg=#f8f8f8
				hi netrwCpp term=NONE cterm=NONE gui=NONE ctermfg=15 guifg=#f8f8f8
				hi netrwSrc term=NONE cterm=NONE gui=NONE ctermfg=15 guifg=#f8f8f8
			else
				hi netrwHdr term=NONE cterm=NONE gui=NONE ctermfg=255 guifg=#f8f8f8
				hi netrwCpp term=NONE cterm=NONE gui=NONE ctermfg=255 guifg=#f8f8f8
				hi netrwSrc term=NONE cterm=NONE gui=NONE ctermfg=255 guifg=#f8f8f8
			endif
		elseif mode == 2
			hi netrwHdr term=NONE cterm=NONE gui=NONE ctermfg=10 guifg=green
			hi netrwCpp term=NONE cterm=NONE gui=NONE ctermfg=10 guifg=green
			hi netrwSrc term=NONE cterm=NONE gui=NONE ctermfg=10 guifg=green
		elseif mode == 3
			hi netrwHdr term=NONE cterm=NONE gui=NONE ctermfg=117 guifg=#87ceeb
			hi netrwCpp term=NONE cterm=NONE gui=NONE ctermfg=117 guifg=#87ceeb
			hi netrwSrc term=NONE cterm=NONE gui=NONE ctermfg=117 guifg=#87ceeb
		endif

		hi netrwData term=NONE cterm=NONE gui=NONE ctermfg=9 guifg=blue
		hi netrwLib term=NONE cterm=NONE gui=NONE ctermfg=13 guifg=magenta
		hi netrwDoc term=NONE cterm=NONE gui=NONE ctermfg=11 guifg=yellow2
		hi netrwObj term=NONE cterm=NONE gui=NONE ctermfg=8 guifg=#808080
		hi netrwCompress term=NONE cterm=NONE gui=NONE ctermfg=11 guifg=yellow
		hi netrwTilde term=NONE cterm=NONE gui=NONE ctermfg=12 guifg=red
		hi netrwTmp	term=NONE cterm=NONE gui=NONE ctermfg=12 guifg=red
		hi netrwSymLink term=NONE cterm=NONE gui=NONE ctermfg=220 ctermbg=27 guifg=grey60
	endif
endfunc

map <leader><F3> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
	\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

augroup ThemeUpdateGroup
	au!
	"au Syntax netrw call s:netrw_highlight()
	"au ColorScheme * GuiThemeHighlight
augroup END



let g:solarized_termcolors=256


if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

nnoremap <leader><F1> :call Tools_ProfileStart('~/.vim/profile.log')<cr>
nnoremap <leader><F2> :call Tools_ProfileStop()<cr>


