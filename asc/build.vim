if (!has('python')) || (!has('timers')) 
	echohl ErrorMsg
	echom "ERROR: Vim must be compiled with +python +timers"
	echohl None
endif

python << __EOF__
import sys, os, subprocess, threading
import threading, time, vim

build_output = []
build_lock = threading.Lock()
build_state = 0
build_start = 0.0
build_time = 0.0

def build_async(args):
	global build_start, build_time, build_state
	def output(text):
		build_lock.acquire()
		build_output.append(text)
		build_lock.release()
		return 0
	def background (args, p):
		global build_time, build_start
		while True:
			text = p.stdout.readline()
			if text in (None, ''):
				break
			text = text.rstrip('\n\r')
			output(text)
		code = p.wait()
		build_time = time.time() - build_start
		build_state = 0
		output(code)
		return 0
	build_start = time.time()
	try:
		p = subprocess.Popen(args, stdout = subprocess.PIPE, \
			stdin = None, stderr = subprocess.STDOUT, shell = True)
	except:
		return -1
	build_state = 1
	t = threading.Thread(target = background, args = (args, p))
	t.daemon = True
	t.start()
	return 0

def build_update(limit):
	global build_output, build_time
	build_lock.acquire()
	result = build_output[:limit]
	build_output = build_output[limit:]
	build_lock.release()
	for line in result:
		if not type(line) in (unicode, str):
			vim.command('call Build_Exit(%d, "%.2f")'%(line, build_time))
		else:
			vim.vars['build_message'] = line
			vim.command('caddexpr g:build_message')
	return 0
__EOF__

let s:state = 0
let g:status_var = ""

function! Build_Exit(code, duration)
	let s:state = 0
	if a:code == 0
		let l:text = "[Finished in ".a:duration." seconds]"
		let g:status_var = "finished"
	else
		let l:text = "[Finished in ".a:duration." seconds with code=".a:code."]"
		let g:status_var = "failed ".a:code 
	endif
	redrawstatus!
	caddexpr l:text
	echom l:text
	if exists('s:timer')
		call timer_stop(s:timer)
		unlet s:timer
	endif

endfunc

function! Build_Start(cmd)
	if !exists('s:timer')
		let s:timer = timer_start(100, 'Build_Timer', {'repeat':-1})
	endif
	if s:state != 0
		echohl ErrorMsg
		echom "ERROR: build job is still running"
		echohl NONE
	elseif a:cmd != ""
		let s:job_time = float2nr(reltimefloat(reltime()))
		python args = vim.eval('a:cmd')
		let l:hr = 0
		python vim.command('let l:hr=%d'%build_async(args))
		if l:hr == 0
			exec "cexpr \'[".fnameescape(a:cmd)."]\'"
			let s:state = 1
			let g:status_var = "building"
		else
			echohl ErrorMsg
			echom "ERROR: Job start failed '".a:cmd."'"
			echohl NONE
		endif
	else
		echo "empty cmd"
	endif
endfunc

function! Build_Timer(id)
	python build_update(100)
endfunc


let g:vimmake_runner = "Build_Start"



