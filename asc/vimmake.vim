" vimmake.vim - Enhenced Customize Make system for vim
"
" Maintainer: skywind3000 (at) gmail.com
" Last change: 2016.5.20
"
" Execute customize tools: ~/.vim/vimmake.{name} directly:
"     :MakeCommand {name}
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
" Settings:
"     g:vimmake_path - change the path of tools rather than ~/.vim/
" 
" Emake can be installed to /usr/local/bin to build C/C++ by: 
"     $ wget https://skywind3000.github.io/emake/emake.py
"     $ sudo python emake.py -i
"
"


"----------------------------------------------------------------------
"- Global Variables
"----------------------------------------------------------------------

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

" error format
if !exists("g:vimmake_match")
	let g:vimmake_match = {}
endif

" single error format
if !exists("g:vimmake_error")
	let g:vimmake_error = "%f:%l:%m"
endif

" change directory to %:p:h before running
if !exists("g:vimmake_cwd")
	let g:vimmake_cwd = 0
endif

" using timer to update quickfix
if !exists('g:vimmake_build_timer')
	let g:vimmake_build_timer = 0
endif

" invoked after async build finished
if !exists('g:vimmake_build_post')
	let g:vimmake_build_post = ''
endif

" build status
if !exists('g:vimmake_build_status')
	let g:vimmake_build_status = ''
endif


"----------------------------------------------------------------------
" Internal Definition
"----------------------------------------------------------------------

" path where vimmake.vim locates
let g:vimmake_home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:vimmake_home = g:vimmake_home
let s:vimmake_advance = 0

" check has advanced mode
if v:version >= 800 || has('patch-7.4.1816')
	if has('job') && has('channel') && has('timers') && has('reltime') 
		let s:vimmake_advance = 1
	endif
endif

" backup local makeprg and errorformat
function! s:MakeSave()
	let s:make_save = &l:makeprg
	let s:match_save = &l:errorformat
endfunc

" restore local makeprg and errorformat
function! s:MakeRestore()
	let &l:makeprg = s:make_save
	let &l:errorformat = s:match_save
endfunc

" init current working directory
function! s:CwdInit()
	if has('s:cwd_save')
		if s:cwd_save != "" | return | endif
	endif
	let s:cwd_save = getcwd()
	let s:cwd_local = haslocaldir()
	let l:cwd = expand("%:p:h")
	if g:vimmake_cwd != 0 && expand("%:p") != ""
		if s:cwd_local == 0
			silent exec 'cd ' . fnameescape(l:cwd)
		else
			silent exec 'lcd ' . fnameescape(l:cwd)
		endif
	endif
endfunc

" restore current working directory
function! s:CwdRestore()
	if exists('s:cwd_save') && exists('s:cwd_local')
		if g:vimmake_cwd != 0 && s:cwd_save != "" 
			if s:cwd_local == 0
				silent exec 'cd '. fnameescape(s:cwd_save)
			else
				silent exec 'lcd '. fnameescape(s:cwd_save)
			endif
		endif
		let s:cwd_save = ""
		unlet s:cwd_save
	endif
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
		silent exec "update"
	elseif g:vimmake_save == 2
		silent exec "wa"
	endif
endfunc

" error message
function! s:ErrorMsg(msg)
	echohl ErrorMsg
	echom 'ERROR: '. a:msg
	echohl NONE
endfunc


"----------------------------------------------------------------------
"- Execute Files
"----------------------------------------------------------------------
function! Vimmake_Execute(mode)
	if a:mode == 0		" Execute current filename
		if has('gui_running') && (has('win32') || has('win64') || has('win16'))
			silent exec '!start cmd /C '.shellescape(expand("%:p")) .' & pause'
		else
			exec '!'.shellescape(expand("%:p"))
		endif
	elseif a:mode == 1	" Execute current filename without extname
		if has('gui_running') && (has('win32') || has('win64') || has('win16'))
			silent exec '!start cmd /C '.shellescape(expand("%:p:r")) .' & pause'
		else
			exec '!'.shellescape(expand("%:p:r"))
		endif
	elseif a:mode == 2
		if has('gui_running') && (has('win32') || has('win64') || has('win16'))
			silent exec '!start cmd /C emake -e '.shellescape(expand("%")).' & pause'
		else
			exec '!emake -e '.shellescape(expand("%"))
		endif
	else
	endif
endfunc


"----------------------------------------------------------------------
"- Execute command in normal(0), quickfix(1), system(2) mode
"----------------------------------------------------------------------
function! Vimmake_Command(command, mode, match)
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
	let $VIM_SVRNAME = v:servername
	let l:text = ''
	if has("gui_running")
		let $VIM_GUI = '1'
	endif
	if (a:mode == 0) || ((!has("quickfix")) && a:mode == 1)
		if has('gui_running') && (has('win32') || has('win64') || has('win16'))
			silent exec '!start cmd /c '. shellescape(a:command) . ' & pause'
		else
			exec '!' . shellescape(a:command)
		endif
	elseif (a:mode == 1)
		call s:MakeSave()
		if a:match == ''
			let &l:errorformat=g:vimmake_error
		else
			let &l:errorformat=a:match
		endif
		let &l:makeprg = a:command
		exec "make!"
		call s:MakeRestore()
	elseif (a:mode == 2)
		let l:text = system("" . shellescape(a:command))
	elseif (a:mode == 3)
		if has('win32') || has('win64') || has('win16')
			silent exec '!start /b cmd.exe /C '. shellescape(a:command)
		else
			system("". shellescape(a:command) . ' &')
		endif
	elseif (a:mode == 4)
		if has('win32') || has('win64') || has('win16')
			silent exec '!start /min cmd.exe /C '. shellescape(a:command) . ' & pause'
		else
			exec '!' . shellescape(a:command)
		endif
	elseif (a:mode == 5)
		if has('python')
			python import vim, subprocess
			python x = [vim.eval('a:command')]
			python m = subprocess.PIPE
			python n = subprocess.STDOUT
			python s = sys.platform[:3] == 'win' and True or False
			python p = subprocess.Popen(x, shell = s, stdout = m, stderr = n)
			python t = p.stdout.read()
			python p.stdout.close()
			python p.wait()
			python t = t.replace('\\', '\\\\').replace('"', '\\"')
			python t = t.replace('\n', '\\n').replace('\r', '\\r')
			python vim.command('let l:text = "%s"'%t)
		else
			echohl ErrorMsg
			echom "ERROR: This vim version does not support python"
			echohl NONE
		endif
	elseif (a:mode == 6)
		if s:vimmake_advance == 0
			let s:msg = "required: +timers +channel +job +reltime and above 7.4.1816"
			call s:ErrorMsg(s:msg)
		else
			call s:Vimmake_Build_Start(a:command)
		endif
	endif
	return l:text
endfunc


"----------------------------------------------------------------------
"- build in background
"----------------------------------------------------------------------
let s:build_output = {}
let s:build_head = 0
let s:build_tail = 0
let s:build_state = 0
let s:build_start = 0.0

" invoked on timer or finished
function! s:Vimmake_Build_Update(count)
	let l:count = 0
	while s:build_tail < s:build_head
		let l:text = s:build_output[s:build_tail]
		unlet s:build_output[s:build_tail]
		let s:build_tail += 1
		caddexpr l:text
		let l:count += 1
		if a:count > 0 && l:count >= a:count
			break
		endif
	endwhile
	return l:count
endfunc

" invoked on timer
function! g:Vimmake_Build_OnTimer(id)
	if exists('s:build_job')
		call job_status(s:build_job)
	endif
	call s:Vimmake_Build_Update(5 + g:vimmake_build_timer)
endfunc

" invoked on "callback" when job output
function! g:Vimmake_Build_OnCallback(channel, text)
	let s:build_output[s:build_head] = a:text
	let s:build_head += 1
	if g:vimmake_build_timer <= 0
		call s:Vimmake_Build_Update(-1)
	endif
endfunc

" because exit_cb and close_cb are disorder, we need OnFinish to guarantee
" both of then have already invoked
function! s:Vimmake_Build_OnFinish(what)
	if s:build_state == 0
		return -1
	endif
	if a:what == 0
		let s:build_state = or(s:build_state, 2)
	else
		let s:build_state = or(s:build_state, 4)
	endif
	if and(s:build_state, 7) != 7
		return -2
	endif
	if exists('s:build_job')
		unlet s:build_job
	endif
	if exists('s:build_timer')
		call timer_stop(s:build_timer)
		unlet s:build_timer
	endif
	call s:Vimmake_Build_Update(-1)
	let l:current = float2nr(reltimefloat(reltime()))
	let l:last = l:current - s:build_start
	caddexpr "[Finished in ".l:last." seconds]"
	let s:build_state = 0
	let g:vimmake_build_status = "success"
	redrawstatus!
endfunc

" invoked on "close_cb" when channel closed
function! g:Vimmake_Build_OnClose(channel)
	while ch_status(a:channel) == 'buffered'
		let l:text = ch_read(a:channel)
		call s:Vimmake_Build_OnCallback(a:channel, l:text)
	endwhile
	call s:Vimmake_Build_Update(-1)
	call s:Vimmake_Build_OnFinish(1)
	if exists('s:build_job')
		call job_status(s:build_job)
	endif
endfunc

" invoked on "exit_cb" when job exited
function! g:Vimmake_Build_OnExit(job, message)
	call s:Vimmake_Build_OnFinish(0)
endfunc

" start background build
function! g:Vimmake_Build_Start(cmd)
	let l:running = 0
	if exists('s:build_job')
		if job_status(s:build_job) == 'run'
			let l:running = 1
		endif
	endif
	if s:build_state != 0 || l:running != 0
		call s:ErrorMsg("background job is still running")
	elseif a:cmd != ''
		let l:args = []
		let l:name = []
		if has('win32') || has('win64') || has('win16')
			let l:args = ['cmd.exe', '/C']
		else
			let l:args = ['/bin/sh', '-c']
		endif
		if type(a:cmd) == 1
			let l:args += [a:cmd]
			let l:name = a:cmd
		elseif type(a:cmd) == 3
			let l:args += a:cmd
			let l:part = []
			for l:x in a:cmd
				let l:part += ['"' . l:x . '"']
			endfor
			let l:name = join(l:part, ', ')
		endif
		let l:options = {}
		let l:options['callback'] = 'g:Vimmake_Build_OnCallback'
		let l:options['close_cb'] = 'g:Vimmake_Build_OnClose'
		let l:options['exit_cb'] = 'g:Vimmake_Build_OnExit'
		let s:build_job = job_start(l:args, l:options)
		if job_status(s:build_job) != 'fail'
			let s:build_output = {}
			let s:build_head = 0
			let s:build_tail = 0
			exec "cexpr \'[".fnameescape(l:name)."]\'"
			let s:build_start = float2nr(reltimefloat(reltime()))
			if g:vimmake_build_timer > 0
				let l:options = {'repeat':-1}
				let l:name = 'g:Vimmake_Build_OnTimer'
				let s:build_timer = timer_start(1000, l:name, l:options)
			endif
			let s:build_state = 1
			let g:vimmake_build_status = "building"
			redrawstatus!
		else
			unlet s:build_job
			call s:ErrorMsg("Background job start failed '".a:cmd."'")
		endif
	else
		echo "empty cmd"
	endif
endfunc


" stop background job
function! Vimmake_Build_Stop(how)
	let l:how = a:how
	if l:how == '' | let l:how = 'term' | endif
	if exists('s:build_job')
		if job_status(s:build_job) == 'run'
			call job_stop(s:build_job, l:how)
		endif
	endif
endfunc


"----------------------------------------------------------------------
"- Execute ~/.vim/vimmake.{command}
"----------------------------------------------------------------------
function! s:Cmd_MakeCommand(bang, command)
	let l:home = expand(g:vimmake_path)
	let l:fullname = "vimmake." . a:command
	let l:fullname = s:PathJoin(l:home, l:fullname)
	let l:value = get(g:vimmake_mode, a:command, '')
	let l:match = get(g:vimmake_match, a:command, '')
	if a:bang != '!'
		silent call s:CheckSave()
	endif
	if type(s:value) == 0 
		let l:mode = string(l:value) 
	else
		let l:mode = s:value
	endif
	if l:match == ''
		let l:match = g:vimmake_error
	endif
	if index(['', '0', 'normal', 'default'], l:mode) >= 0
		call Vimmake_Command(l:fullname, 0, l:match)
	elseif index(['1', 'quickfix', 'make', 'makeprg'], l:mode) >= 0
		call Vimmake_Command(l:fullname, 1, l:match)
	elseif index(['2', 'system', 'silent'], l:mode) >= 0
		call Vimmake_Command(l:fullname, 2, l:match)
	elseif index(['3', 'background', 'bg'], l:mode) >= 0
		call Vimmake_Command(l:fullname, 3, l:match)
	elseif index(['4', 'minimal', 'm', 'min'], l:mode) >= 0
		call Vimmake_Command(l:fullname, 4, l:match)
	elseif index(['5', 'python', 'p', 'py'], l:mode) >= 0
		call Vimmake_Command(l:fullname, 5, l:match)
	elseif index(['6', 'async', 'job', 'channel'], l:mode) >= 0
		call Vimmake_Command(l:fullname, 6, l:match)
	else
		call s:ErrorMsg("invalid mode: ".l:mode)
	endif
	return l:fullname
endfunc


" command definition
command! -bang -nargs=1 MakeCommand call s:Cmd_MakeCommand('<bang>', <f-args>)

" build via gcc
function! Vimmake_CompileGcc()
	silent call s:CheckSave()
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
	silent call s:CheckSave()
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


"----------------------------------------------------------------------
"- run current file by detecting file extname
"----------------------------------------------------------------------
function! Vimmake_Run(bang, mode, cwd)
	silent call s:CheckSave()
	if bufname('%') == '' | return | endif
	let l:ext = expand("%:e")
	call s:CwdInit()
	if index(['c', 'cpp', 'cc', 'm', 'mm', 'cxx', 'h', 'hh', 'hpp'], l:ext) >= 0
		exec "call Vimmake_Execute(1)"
	elseif index(['mak', 'emake'], l:ext) >= 0
		exec "call Vimmake_Execute(2)"
	elseif &filetype == "vim"
		exec 'source ' . fnameescape(expand("%"))
	elseif has('gui_running') && (has('win32') || has('win64') || has('win16'))
		if index(['py', 'pyw', 'pyc', 'pyo'], l:ext) >= 0
			silent exec '!start cmd /C python ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext  == "js"
			silent exec '!start cmd /C node ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'sh'
			silent exec '!start cmd /C sh ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'lua'
			silent exec '!start cmd /C lua ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'pl'
			silent exec '!start cmd /C perl ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'rb'
			silent exec '!start cmd /C ruby ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'php'
			silent exec '!start cmd /C php ' . shellescape(expand("%")) . ' & pause'
		elseif index(['osa', 'scpt', 'applescript'], l:ext) >= 0
			silent exec '!start cmd /C osascript '.shellescape(expand('%')).' & pause'
		else
			call Vimmake_Execute(0)
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
			call Vimmake_Execute(0)
		endif
	endif
	call s:CwdRestore()
endfunc





