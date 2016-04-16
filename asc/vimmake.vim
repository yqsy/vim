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
"     $VIM_GUI       - Is running under gui ?
"     $VIM_VERSION   - Value of v:version
"     $VIM_MODE      - Execute via 0:!, 1:makeprg, 2:system()
"     $VIM_SCRIPT    - Home path of tool scripts
"
"
" Execute customize tools: ~/.vim/vimmake.{name} directly:
"     :VimMake {name}
"
" Execute customize tools: ~/.vim/vimmake.{name} in quickfix mode:
"     :VimMake! {name}
"
" Execute customize tools: ~/.vim/vimmake.{name} in silent mode:
"     :VimExec! {name}
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

" default tool location is ~/.vim which could be changed by g:vimmake_path
if !exists("g:vimmake_path")
	let g:vimmake_path = "~/.vim"
endif

" don't save file by default
if !exists("g:vimmake_save")
	let g:vimmake_save = 0
endif

" default gcc cflags
if !exists("g:vimmake_cflags")
	let g:vimmake_cflags = ""
endif

" default modes
if !exists("g:vimmake_mode")
	let g:vimmake_mode = {}
endif

" path where vimmake.vim locates
let g:vimmake_home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:vimmake_home = g:vimmake_home

" Execute current filename directly
function! Vimmake_ExeFile()
	if has('gui_running') && (has('win32') || has('win64') || has('win16'))
		exec '!start cmd /C '. shellescape(expand("%:p")) . ' & pause'
	else
		exec '!' . shellescape(expand("%:p"))
	endif
endfunc

" Execute current filename without extname
function! Vimmake_ExeMain()
	if has('gui_running') && (has('win32') || has('win64') || has('win16'))
		exec '!start cmd /C '. shellescape(expand("%:p:r")) . ' & pause'
	else
		exec '!' . shellescape(expand("%:p:r"))
	endif
endfunc

" Execute executable of current emake project
function! Vimmake_ExeEmake()
	if has('gui_running') && (has('win32') || has('win64') || has('win16'))
		exec '!start cmd /C emake -e '. shellescape(expand("%")) . ' & pause'
	else
		exec '!emake -e ' . shellescape(expand("%"))
	endif
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


" Execute command in normal(0), quickfix(1), system(2) mode
function! Vimmake_Execute(command, mode)
	let $VIM_FILEPATH = expand("%:p")
	let $VIM_FILENAME = expand("%:t")
	let $VIM_FILEDIR = expand("%:p:h")
	let $VIM_FILENOEXT = expand("%:t:r")
	let $VIM_FILEEXT = "." . expand("%:e")
	let $VIM_CWD = expand("%:p:h:h")
	let $VIM_RELDIR = expand("%:h")
	let $VIM_RELNAME = expand("%:p:.")
	let $VIM_CWORD = expand("<cword>")
	let $VIM_VERSION = ''.v:version
	let $VIM_MODE = ''. a:mode
	let $VIM_GUI = '0'
	let $VIM_SCRIPT = g:vimmake_path
	let l:text = ''
	if has("gui_running")
		let $VIM_GUI = '1'
	endif
	if (a:mode == 0) || ((!has("quickfix")) && a:mode == 1)
		if has('gui_running') && (has('win32') || has('win64') || has('win16'))
			exec '!start cmd /c '. shellescape(a:command) . ' & pause'
		else
			exec '!' . shellescape(a:command)
		endif
	elseif (a:mode == 1)
		call s:MakeSave()
		setlocal errorformat=%f:%l:%m
		exec "setlocal makeprg=" . fnameescape(a:command)
		exec "make!"
		call s:MakeRestore()
	elseif (a:mode == 2)
		let l:text = system("" . shellescape(a:command))
	elseif (a:mode == 3)
		if has('gui_running') && (has('win32') || has('win64') || has('win16'))
			exec '!start /b cmd /C '. shellescape(a:command)
		else
			silent call system("". shellescape(a:command))
		endif
	endif
	return l:text
endfunc


" join two path
function! s:PathJoin(home, name)
    let l:size = strlen(a:home)
    if l:size == 0 | return a:name | endif
    let l:last = strpart(a:home, l:size - 1, 1)
    if has("win32") || has("win64") || has("win16") 
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

" save file
function! s:CheckSave()
	if bufname('%') == '' || getbufvar('%', '&modifiable') == 0
		return
	endif
	if g:vimmake_save == 1
		silent exec "w"
	elseif g:vimmake_save == 2
		silent exec "wa"
	endif
endfunc

" error message
function! s:ErrorMsg(msg)
	echohl ErrorMsg
	echom a:msg
	echohl NONE
endfunc

" Execute ~/.vim/vimmake.{command} 
function! s:VimMake(bang, command)
	call s:CheckSave()
	let l:home = expand(g:vimmake_path)
	let l:fullname = "vimmake." . a:command
	let l:fullname = s:PathJoin(l:home, l:fullname)
	if a:bang == ''
		call Vimmake_Execute(l:fullname, 0)
	elseif a:bang == '!'
		call Vimmake_Execute(l:fullname, 1)
	elseif a:bang == '?'
		call Vimmake_Execute(l:fullname, 2)
	else
		call Vimmake_Execute(l:fullname, 3)
	endif
	return l:fullname
endfunc

" Execute ~/.vim/vimmake.{command}
function! s:VimExec(bang, command)
	if a:bang == ''
		return s:VimMake('', a:command)
	else
		return s:VimMake('?', a:command)
	endif
endfunc

" Execute ~/.vim/vimmake.{command} with mode in g:vimmake_mode
function! s:VimTool(command)
	let s:value = get(g:vimmake_mode, a:command, '')
	let s:mode = ''
	if type(s:value) == 0 
		let s:mode = string(s:value) 
	else
		let s:mode = s:value
	endif
	if index(['1', 'quickfix', 'make', 'makeprg'], s:mode) >= 0
		call s:VimMake('!', a:command)
	elseif index(['2', 'system', 'silent'], s:mode) >= 0
		let l:text = s:VimMake('?', a:command)
		echom "VimTool: ".l:text
	else
		call s:VimMake('', a:command)
	endif
endfunc

" command definition
command! -bang -nargs=1 VimMake call s:VimMake('<bang>', <f-args>)
command! -bang -nargs=1 VimExec call s:VimExec('<bang>', <f-args>)
command! -nargs=1 VimTool call s:VimTool(<f-args>)

" build via gcc
function! Vimmake_CompileGcc()
	call s:CheckSave()
	if bufname('%') == '' | return | endif
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
function! Vimmake_BuildEmake(filename, ininame, quickfix)
	call s:CheckSave()
	if bufname('%') == '' | return | endif
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
function! Vimmake_RunClever()
	call s:CheckSave()
	if bufname('%') == '' | return | endif
	let l:ext = expand("%:e")
	if index(['c', 'cpp', 'cc', 'm', 'mm', 'cxx'], l:ext) >= 0
		exec "call Vimmake_ExeMain()"
	elseif index(['mak', 'emake'], l:ext) >= 0
		exec "call Vimmake_ExeEmake()"
	elseif &filetype == "vim"
		exec 'source ' . fnameescape(expand("%"))
	elseif has('gui_running') && (has('win32') || has('win64') || has('win16'))
		if index(['py', 'pyw', 'pyc', 'pyo'], l:ext) >= 0
			exec '!start cmd /C python ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext  == "js"
			exec '!start cmd /C node ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'sh'
			exec '!start cmd /C sh ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'lua'
			exec '!start cmd /C lua ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'pl'
			exec '!start cmd /C perl ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'rb'
			exec '!start cmd /C ruby ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'php'
			exec '!start cmd /C php ' . shellescape(expand("%")) . ' & pause'
		elseif index(['osa', 'scpt', 'applescript'], l:ext) >= 0
			exec '!start cmd /C osascript '. shellescape(expand('%')) . ' & pause'
		else
			call Vimmake_ExeFile()
		endif
	else
		if index(['py', 'pyw', 'pyc', 'pyo'], l:ext) >= 0
			exec '!python ' . shellescape(expand("%"))
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
		elseif index(['osa', 'scpt', 'applescript'], l:ext) >= 0
			exec '!osascript '. shellescape(expand('%'))
		else
			call Vimmake_ExeFile()
		endif
	endif
endfunc


noremap <silent><F5> :call Vimmake_RunClever()<CR>
inoremap <silent><F5> <ESC>:call Vimmake_RunClever()<CR>

noremap <silent><F6> :call Vimmake_ExeFile()<CR>
inoremap <silent><F6> <ESC>:call Vimmake_ExeFile()<CR>

noremap <silent><F7> :call Vimmake_BuildEmake(expand("%"), "", 1)<CR>
inoremap <silent><F7> <ESC>:call Vimmake_BuildEmake(expand("%"), "", 1)<CR>

noremap <silent><F8> :call Vimmake_ExeEmake()<CR>
inoremap <silent><F8> <ESC>:call Vimmake_ExeEmake()<CR>

noremap <silent><F9> :call Vimmake_CompileGcc()<CR>
inoremap <silent><F9> <ESC>:call Vimmake_CompileGcc()<CR>


noremap <silent><F11> :cp<cr>
noremap <silent><F12> :cn<cr>
inoremap <silent><F11> <ESC>:cp<cr>
inoremap <silent><F12> <ESC>:cn<cr>

noremap <silent><leader>cp :cp<cr>
noremap <silent><leader>cn :cn<cr>
noremap <silent><leader>co :copen 6<cr>
noremap <silent><leader>cl :cclose<cr>

for s:i in range(10)
	let s:name = '<F' . s:i . '>'
	if s:i == 0
		let s:name = '<F10>'
	endif
	exec 'noremap <silent><leader>' . s:name . ' :VimMake ' . s:i . '<cr>'
	exec 'noremap <silent><tab>' . s:name . ' :VimMake! ' . s:i . '<cr>'
endfor


" grep code
let g:vimmake_grepinc = ['c', 'cpp', 'cc', 'h', 'hpp', 'hh']
let g:vimmake_grepinc += ['m', 'mm', 'py', 'js', 'php', 'java']

function! s:GrepCode(text)
	let l:grep = &grepprg
	if strpart(l:grep, 0, 8) == 'findstr '
		let l:inc = ''
		for l:item in g:vimmake_grepinc
			let l:inc .= '*.'.l:item.' '
		endfor
		exec 'grep! /s "'. a:text . '" '. l:inc
	else
		let l:inc = ''
		for l:item in g:vimmake_grepinc
			let l:inc .= " --include \\*." . l:item
		endfor
		exec 'grep! -R ' . shellescape(a:text) . l:inc. ' *'
	endif
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



