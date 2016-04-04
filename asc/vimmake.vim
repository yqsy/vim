" vimmake.vim - Enhenced Customize Make system for vim
"
" Maintainer: skywind3000 (at) gmail.com
" Last change: 2016.3.20
"
" Execute customize tools directly:
"     <leader><F1-F9> execute ~/.vim/vimmake.1 - ~/.vim/vimmake.9
"
" Execute customize tools in quickfix mode:
"     <tab><F1-F9> execute ~/.vim/vimmake.1 - ~/.vim/vimmake.9
"
" Environment variables are set to below before executing:
"     $VIM_FILEPATH  - File name of current buffer with full path
"     $VIM_FILENAME  - File name of current buffer without path
"     $VIM_FILEDIR   - Full path of current buffer without the file name
"     $VIM_FILEEXT   - File extension of current buffer
"     $VIM_FILENOEXT - File name of current buffer without path and extension
"     $VIM_CWD       - Current directory
"     $VIM_RELDIR    - File path relativize to current directory
"     $VIM_RELNAME   - File name relativize to current directory 
"     $VIM_CWORD     - Current word in the buffer
"
"
" Execute customize tools: ~/.vim/vimmake.{name} directly:
"     :Vimmake {name}
"
" Execute customize tools: ~/.vim/vimmake.{name} in quickfix mode:
"     :Vimmake! {name}
"
" Support:
"     <F5>  Run current file by detecting file type
"     <F6>  Execute current file directly
"     <F7>  Build with emake
"     <F8>  Execute emake project
"     <F9>  Compile with gcc/clang
"     <F10> Toggle quickfix window
"     <F11> Previous quickfix error
"     <F12> Next quickfix error
" 
" Emake can be installed to /usr/local/bin to build C/C++ by: 
"     $ wget https://skywind3000.github.io/emake/emake.py
"     $ sudo python emake.py -i
"
"

" default tool location is ~/.vim which could be changed by g:vimmake_home
if !exists("g:vimmake_home")
	let g:vimmake_home = "~/.vim"
endif

" Execute current filename directly
function! ExecuteFile()
	exec '!' . shellescape(expand("%:p"))
endfunc

" Execute current filename without extname
function! ExecuteMain()
	exec '!' . shellescape(expand("%:p:r"))
endfunc

" Execute executable of current emake project
function! ExecuteEmake()
	exec '!emake -e ' . shellescape(expand("%"))
endfunc

" backup local makeprg and errorformat
function! s:MakeSave()
	let s:make_save = &makeprg
	let s:match_save = &errorformat
endfunc

" restore local makeprg and errorformat
function! s:MakeRestore()
	exec 'setlocal makeprg=' . fnameescape(s:make_save)
	exec 'setlocal errorformat=' . fnameescape(s:match_save)
endfunc



" Execute command in both quickfix and non-quickfix mode
function! ExecuteCommand(command, quickfix)
	let $VIM_FILEPATH = expand("%:p")
	let $VIM_FILENAME = expand("%:t")
	let $VIM_FILEDIR = expand("%:p:h")
	let $VIM_FILENOEXT = expand("%:t:r")
	let $VIM_FILEEXT = "." . expand("%:e")
	let $VIM_CWD = expand("%:p:h:h")
	let $VIM_RELDIR = expand("%:h")
	let $VIM_RELNAME = expand("%:p:.")
	let $VIM_CWORD = expand("<cword>")
	if (!a:quickfix) || (!has("quickfix"))
		exec '!' . shellescape(a:command)
	else
		call s:MakeSave()
		setlocal errorformat=%f:%l:%m
		exec "setlocal makeprg=" . fnameescape(a:command)
		exec "make!"
		call s:MakeRestore()
	endif
endfunc


" global CFLAGS to be passed to gcc
let g:vimmake_cflags = ''
let g:vimmake_save = 0

" join two path
function! s:PathJoin(home, name)
    let l:size = strlen(a:home)
    if l:size == 0 | return a:name | endif
    let l:last = strpart(a:home, l:size - 1, 1)
    if has("win32") || has("win64") || has("win16") || has("windows")
        if l:last == "/" || l:last == "\\"
            return a:home . a:name
        else
            return a:home . '/' . a:name
        endif
    else
        if l:last == "/"
            return a:home . a:name
        else
            return a:home . '/' . a:name
        endif
    endif
endfunc

" Execute ~/.vim/vimmake.{command} 
function! s:VimMake(bang, command)
	if g:vimmake_save
		exec "w"
	endif
	let l:home = expand(g:vimmake_home)
	let l:fullname = "vimmake." . a:command
	let l:fullname = s:PathJoin(l:home, l:fullname)
	if a:bang == ''
		call ExecuteCommand(l:fullname, 0)
	else
		call ExecuteCommand(l:fullname, 1)
	endif
endfunc

" command definition
command! -bang -nargs=1 Vimmake call s:VimMake('<bang>', <f-args>)

" build via gcc
function! CompileGcc()
	if g:vimmake_save
		exec "w"
	endif
	let l:compileflag = g:vimmake_cflags
	let l:extname = expand("%:e")
	if index(['cpp', 'cc', 'cxx', 'mm'], l:extname)
		let l:compileflag .= ' -lstdc++'
	endif
	if !has("quickfix")
		exec '!gcc -Wall "%" -o "%<" ' . l:compileflag
	else
		call s:MakeSave()
		let l:cflags = substitute(l:compileflag, ' ', '\\ ', 'g')
		let l:cflags = substitute(l:cflags, '"', '\\"', 'g')
		exec 'setlocal makeprg=gcc\ -Wall\ \"%\"\ -o\ \"%<\"\ ' . l:cflags
		setlocal errorformat=%f:%l:%m
		exec 'make!'
		call s:MakeRestore()
	endif
endfunc


" build via emake (http://skywind3000.github.io/emake/emake.py)
function! BuildEmake(filename, ininame, quickfix)
	if g:vimmake_save
		exec "w"
	endif
	if (!a:quickfix) || (!has("quickfix"))
		if a:ininame == ''
			exec '!emake ' . shellescape(a:filename) . ''
		else
			exec '!emake "--ini=' . a:ininame . '" ' . shellescape(a:filename) . ''
		endif
	else
		call s:MakeSave()
		setlocal errorformat=%f:%l:%m
		let l:fname = '\"' . fnameescape(a:filename) . '\"'
		if a:ininame == ''
			exec 'setlocal makeprg=emake\ ' . l:fname 
			exec "make!"
		else
			exec 'setlocal makeprg=emake\ \"--ini=' . a:ininame . '\"\ ' . l:fname
			exec "make!"
		endif
		call s:MakeRestore()
	endif
endfunc


" run current file by detecting file extname
function! RunClever()
	if g:vimmake_save
		exec "w"
	endif
	let l:ext = expand("%:e")
	if index(['c', 'cpp', 'cc', 'm', 'mm', 'cxx'], l:ext) >= 0
		exec "call ExecuteMain()"
	elseif index(['py', 'pyw', 'pyc', 'pyo'], l:ext) >= 0
		exec '!python ' . fnameescape(expand("%"))
	elseif index(['mak', 'emake'], l:ext) >= 0
		exec "call ExecuteEmake()"
	elseif &filetype == "vim"
		exec 'source ' . fnameescape(expand("%"))
	elseif l:ext  == "js"
		exec '!node ' . shellescape(expand("%"))
	elseif l:ext == 'sh'
		exec '!sh ' . shellescape(expand("%"))
	elseif l:ext == 'lua'
		exec '!lua ' . shellescape(expand("%"))
	elseif l:ext == 'pl'
		exec '!perl ' . shellescape(expand("%"))
	elseif l:ext == 'rb'
		exec '!ruby ' . shellescape(expand("%"))
	elseif l:ext == 'php'
		exec '!php ' . shellescape(expand("%"))
	else
		call ExecuteFile()
	endif
endfunc


noremap <silent><F5> :call RunClever()<CR>
inoremap <silent><F5> <C-o>:call RunClever()<CR>

noremap <silent><F6> :call ExecuteFile()<CR>
inoremap <silent><F6> <C-o>:call ExecuteFile()<CR>

noremap <silent><F7> :call BuildEmake(expand("%"), "", 1)<CR>
inoremap <silent><F7> <C-o>:call BuildEmake(expand("%"), "", 1)<CR>

noremap <silent><F8> :call ExecuteEmake()<CR>
inoremap <silent><F8> <C-o>:call ExecuteEmake()<CR>

noremap <silent><F9> :call CompileGcc()<CR>
inoremap <silent><F9> <C-o>:call CompileGcc()<CR>


noremap <silent><F11> :cp<cr>
noremap <silent><F12> :cn<cr>
inoremap <silent><F11> <C-o>:cp<cr>
inoremap <silent><F12> <C-o>:cn<cr>

noremap <silent><leader>cp :cp<cr>
noremap <silent><leader>cn :cn<cr>
noremap <silent><leader>co :copen 6<cr>
noremap <silent><leader>cl :cclose<cr>

for s:i in range(10)
	let s:name = '<F' . s:i . '>'
	if s:i == 0
		let s:name = '<F10>'
	endif
	exec 'noremap <silent><leader>' . s:name . ' :Vimmake ' . s:i . '<cr>'
	exec 'noremap <silent><tab>' . s:name . ' :Vimmake! ' . s:i . '<cr>'
endfor


" grep code
let g:vimmake_grepinc = ['c', 'cpp', 'cc', 'h', 'hpp', 'hh']
let g:vimmake_grepinc += ['m', 'mm', 'py', 'js', 'php', 'java']

function! s:GrepCode(text)
	let l:inc = ''
	for l:item in g:vimmake_grepinc
		let l:inc .= " --include \\*." . l:item
	endfor
	exec 'grep! -R ' . shellescape(a:text) . l:inc. ' *'
endfunc


command! -nargs=1 GrepCode call s:GrepCode(<f-args>)

" set keymap to GrepCode 
noremap <silent><leader>cr :GrepCode <C-R>=expand("<cword>")<cr><cr>

function! Vimmake_Update_FileList(outname)
	let l:names = ['*.c', '*.cpp', '*.cc', '*.cxx']
	let l:names += ['*.h', '*.hpp', '*.hh', '*.py', '*.pyw', '*.java', '*.js']
	if has('win32') || has("win64") || has("win16")
		silent! exec '!dir /b ' . join(l:names, ',') . ' > '.a:outname
	else
		let l:cmd = ''
		let l:ccc = 1
		for l:name in l:names
			if l:ccc == 1
				let l:cmd .= ' -name "'.l:name . '"'
				let l:ccc = 0
			else
				let l:cmd .= ' -o -name "'.l:name. '"'
			endif
		endfor
		silent! exec '!find . ' . l:cmd . ' > '.a:outname
	endif
	redraw!
endfunc

function! Vimmake_Update_Tags(ctags, cscope)
	echo "update tags"
	if a:ctags != "" 
		if filereadable(a:ctags) | call delete(a:ctags) | endif
		let l:parameters = ' --fields=+iaS --extra=+q --c++-kinds=+px '
		exec '!ctags -R -f '.a:ctags. l:parameters . ' .'
	endif
	if has("cscope") && a:cscope != ""
		silent! exec "cs kill -1"
		if filereadable(a:cscope) | call delete(a:cscope) | endif
		exec '!cscope -b -R -f '.a:cscope
		if filereadable(a:cscope)
			exec 'cs add '.a:cscope
		endif
	endif
	redraw!
endfunc

" cscope update
noremap <leader>ca :call Vimmake_Update_Tags('.tags', '')<cr>
noremap <leader>cm :call Vimmake_Update_Tags('', '.cscope')<cr>

" set keymap to cscope
if has("cscope")
	noremap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
	noremap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
	noremap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
	noremap <leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>
	noremap <leader>ce :cs find e <C-R>=expand("<cword>")<CR><CR>
	noremap <leader>cf :cs find f <C-R>=expand("<cword>")<CR><CR>
	noremap <leader>ci :cs find i <C-R>=expand("<cword>")<CR><CR>
	noremap <leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    set csto=0
    set cst
    set csverb
endif


" switch header
function! Vimmake_Switch_Header()
	let l:main = expand('%:p:r')
	let l:fext = expand('%:e')
	if index(['c', 'cpp', 'm', 'mm', 'cc'], l:fext) >= 0
		let l:altnames = ['h', 'hpp', 'hh']
	elseif index(['h', 'hh', 'hpp'], l:fext) >= 0
		let l:altnames = ['c', 'cpp', 'cc', 'm', 'mm']
	else
		echo 'switch failed, not a c/c++ source'
		return
	endif
	for l:next in l:altnames
		let l:newname = l:main . '.' . l:next
		if filereadable(l:newname)
			exec 'vs ' . fnameescape(l:newname)
			return
		endif
	endfor
	echo 'switch failed, can not find another part of c/c++ source'
endfunc

noremap <leader>ch :call Vimmake_Switch_Header()<cr>
noremap <leader>cw :!man -S 3:2:1 <C-R>=expand("<cword>")<CR><CR>


