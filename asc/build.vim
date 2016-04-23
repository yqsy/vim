if (!has('job')) || (!has('reltime')) 
	echohl ErrorMsg
	echom "ERROR: Vim must be compiled with +job"
	echohl None
endif

let s:job_time = 0

function! Build_JobHook(channel, msg)
	caddexpr a:msg
endfunc

function! Build_JobExit(channel, msg)
	let l:now = float2nr(reltimefloat(reltime()))
	let l:last = l:now - s:job_time
	let l:text = "[Finished in ".l:last." seconds]"
	caddexpr l:text
	echom l:text
endfunc

function! Build_Start(cmd)
	let l:option = { 'callback': 'Build_JobHook', 'exit_cb': 'Build_JobExit' }
	let l:running = 0
	if exists('s:job_desc')
		if job_status(s:job_desc) == 'run'
			let l:running = 1
		endif
	endif
	if l:running != 0
		echohl ErrorMsg
		echom "ERROR: build job is still running"
		echohl NONE
	elseif a:cmd != ""
		cexpr ""
		let s:job_time = float2nr(reltimefloat(reltime()))
		if has('win32') || has('win64') || has('win16')
			let s:job_desc = job_start(['cmd.exe', '/C', a:cmd], l:option)
		else
			let s:job_desc = job_start(['/bin/sh', '-c', a:cmd], l:option)
		endif
		if job_status(s:job_desc) != 'fail'
			echo "Build: ".a:cmd
		else
			echohl ErrorMsg
			echom "ERROR: Job start failed '".a:cmd."'"
			echohl NONE
		endif
	else
		echo "empty cmd"
	endif
endfunc


let g:vimmake_runner = "Build_Start"


