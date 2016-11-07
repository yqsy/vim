"======================================================================
"
" asclib.vim - autoload methods
"
" Created by skywind on 2016/10/28
" Last change: 2016/10/28 00:38:10
"
"======================================================================


"----------------------------------------------------------------------
" window basic
"----------------------------------------------------------------------

" save all window's view
function! asclib#window_saveview()
	function! s:window_view_save()
		let w:asclib_window_view = winsaveview()
	endfunc
	let l:winnr = winnr()
	windo call s:window_view_save()
	silent! exec ''.l:winnr.'wincmd w'
endfunc

" restore all window's view
function! asclib#window_loadview()
	function! s:window_view_rest()
		if exists('w:asclib_window_view')
			call winrestview(w:asclib_window_view)
			unlet w:asclib_window_view
		endif
	endfunc
	let l:winnr = winnr()
	windo call s:window_view_rest()
	silent! exec ''.l:winnr.'wincmd w'
endfunc

" unique window id
function! asclib#window_uid(tabnr, winnr)
	let name = 'asclib_window_unique_id'
	let uid = gettabwinvar(a:tabnr, a:winnr, name)
	if type(uid) == 1 && uid == ''
		if !exists('s:asclib_window_unique_index')
			let s:asclib_window_unique_index = 1000
			let s:asclib_window_unique_rewind = 0
			let uid = 1000
			let s:asclib_window_unique_index += 1
		else
			let uid = 0
			if !exists('s:asclib_window_unique_rewind')
				let s:asclib_window_unique_rewind = 0
			endif
			if s:asclib_window_unique_rewind == 0 
				let uid = s:asclib_window_unique_index
				let s:asclib_window_unique_index += 1
				if s:asclib_window_unique_index >= 100000
					let s:asclib_window_unique_rewind = 1
					let s:asclib_window_unique_index = 1000
				endif
			else
				let name = 'asclib_window_unique_id'
				let index = s:asclib_window_unique_index
				let l:count = 0
				while l:count < 100000
					let found = 0
					for l:tabnr in range(1, tabpagenr('$'))
						for l:winnr in range(1, tabpagewinnr(l:tabnr, '$'))
							if gettabwinvar(l:tabnr, l:winnr, name) is index
								let found = 1
								break
							endif
						endfor
						if found != 0
							break
						endif
					endfor
					if found == 0
						let uid = index
					endif
					let index += 1
					if index >= 100000
						let index = 1000
					endif
					let l:count += 1
					if found == 0
						break
					endif
				endwhile
				let s:asclib_window_unique_index = index
			endif
			if uid == 0
				echohl ErrorMsg
				echom "error allocate new window uid"
				echohl NONE
				return -1
			endif
		endif
		call settabwinvar(a:tabnr, a:winnr, name, uid)
	endif
	return uid
endfunc

" unique window id to [tabnr, winnr], [0, 0] for not find
function! asclib#window_find(uid)
	let name = 'asclib_window_unique_id'
	" search current tabpagefirst
	for l:winnr in range(1, winnr('$'))
		if gettabwinvar('%', l:winnr, name) is a:uid
			return [tabpagenr(), l:winnr]
		endif
	endfor
	" search all the tabpages
	for l:tabnr in range(1, tabpagenr('$'))
		for l:winnr in range(1, tabpagewinnr(l:tabnr, '$'))
			if gettabwinvar(l:tabnr, l:winnr, name) is a:uid
				return [l:tabnr, l:winnr]
			endif
		endfor
	endfor
	return [0, 0]
endfunc

" switch to tabwin
function! asclib#window_goto_tabwin(tabnr, winnr)
	if a:tabnr != '' && a:tabnr != '%'
		if tabpagenr() != a:tabnr
			silent! exec "tabn ". a:tabnr
		endif
	endif
	if winnr() != a:winnr
		silent! exec ''.a:winnr.'wincmd w'
	endif
endfunc

" switch to window by uid
function! asclib#window_goto_uid(uid)
	let [l:tabnr, l:winnr] = asclib#window_find(a:uid)
	if l:tabnr == 0 || l:winnr == 0
		return 1
	endif
	call asclib#window_goto_tabwin(l:tabnr, l:winnr)
	return 0
endfunc

" new window and return window uid, zero for error
function! asclib#window_new(position, size)
	function! s:window_new_action(mode)
		if a:mode == 0
			let w:asclib_window_saveview = winsaveview()
		else
			if exists('w:asclib_window_saveview')
				call winrestview(w:asclib_window_saveview)
				unlet w:asclib_window_saveview
			endif
		endif
	endfunc
	let uid = asclib#window_uid('%', '%')
	let retval = 0
	windo call s:window_new_action(0)
	call asclib#window_goto_uid(uid)
	silent! exec ''.l:winnr.'wincmd w'
	if a:position == 'top' || a:position == '0'
		if a:size <= 0
			leftabove new 
		else
			exec 'leftabove '.a:size.'new'
		endif
	elseif a:position == 'bottom' || a:position == '1'
		if a:size <= 0
			rightbelow new
		else
			exec 'rightbelow '.a:size.'new'
		endif
	elseif a:position == 'left' || a:position == '2'
		if a:size <= 0
			leftabove vnew
		else
			exec 'leftabove '.a:size.'vnew'
		endif
	elseif a:position == 'right' || a:position == '3'
		if a:size <= 0
			rightbelow vnew
		else
			exec 'rightbelow '.a:size.'vnew'
		endif
	else
		rightbelow vnew
	endif
	let retval = asclib#window_uid('%', '%')
	windo call s:window_new_action(1)
	call asclib#window_goto_uid(uid)
	return retval
endfunc


"----------------------------------------------------------------------
" preview window
"----------------------------------------------------------------------
if !exists('g:asclib_preview_position')
	let g:asclib_preview_position = "right"
endif

if !exists('g:asclib_preview_vsize')
	let g:asclib_preview_vsize = 0
endif

if !exists('g:asclib_preview_size')
	let g:asclib_preview_size = 0
endif


" check preview window is open ?
function! asclib#preview_check()
	function! s:preview_check()
		if &previewwindow
			let s:preview_check_result = asclib#window_uid('%', '%')
		endif
	endfunc
	let l:winnr = winnr()
	let s:preview_check_result = 0
	windo call s:preview_check()
	silent! exec ''.l:winnr.'wincmd w'
	return s:preview_check_result
endfunc


" open preview vertical or horizon
function! asclib#preview_open()
	function! s:preview_action(mode)
		if a:mode == 0
			let w:asclib_preview_save = winsaveview()
		else
			if exists('w:asclib_preview_save')
				call winrestview(w:asclib_preview_save)
				unlet w:asclib_preview_save
			endif
		endif
	endfunc
	let pid = asclib#preview_check()
	if pid == 0
		let uid = asclib#window_uid('%', '%')
		let pos = g:asclib_preview_position
		if pos == 'top' || pos == 'bottom' || pos == '0' || pos == '1'
			let pid = asclib#window_new(pos, g:asclib_preview_size)
		else
			let pid = asclib#window_new(pos, g:asclib_preview_vsize)
		endif
		if pid > 0
			call asclib#window_goto_uid(pid)
			set previewwindow
		endif
		call asclib#window_goto_uid(uid)
	endif
	return pid
endfunc

" close preview window
function! asclib#preview_close()
	silent pclose
endfunc

" echo error message
function! asclib#errmsg(msg)
	echohl ErrorMsg
	echom a:msg
	echohl NONE
endfunc

" echo cmdline message
function! asclib#cmdmsg(content, highlight)
	let saveshow = &showmode
	set noshowmode
    let wincols = &columns
    let allowedheight = &lines/5
    let statusline = (&laststatus==1 && winnr('$')>1) || (&laststatus==2)
    let reqspaces_lastline = (statusline || !&ruler) ? 12 : 29
    let width = len(a:content)
    let limit = wincols - reqspaces_lastline
	let allowedheight = &cmdheight
	let l:content = a:content
	if width + 1 > limit
		let l:content = strpart(l:content, 0, limit - 1)
		let width = len(l:content)
	endif
	if a:highlight != 0
		echohl Type
		echo l:content
		echohl NONE
	else
		echo l:content
	endif
	if saveshow != 0
		set showmode
	endif
endfunc


"----------------------------------------------------------------------
" taglist
"----------------------------------------------------------------------
function! asclib#taglist(pattern)
    let ftags = []
    try
        let ftags = taglist(a:pattern)
    catch /^Vim\%((\a\+)\)\=:E/
        " if error occured, reset tagbsearch option and try again.
        let bak = &tagbsearch
        set notagbsearch
        let ftags = taglist(a:pattern)
        let &tagbsearch = bak
    endtry
    return ftags
endfunc



"----------------------------------------------------------------------
" easy tagname
"----------------------------------------------------------------------
function! asclib#tagfind(tagname)
	let pattern = escape(a:tagname, '[\*~^')
	let result = asclib#taglist("^". pattern . "$")
	if result == []
		if pattern !~ '^\(catch\|if\|for\|while\|switch\)$'
			let result = asclib#taglist('::'. pattern .'$')
		endif
	endif
	return result
endfunc


"----------------------------------------------------------------------
" display matched tag in the preview window
"----------------------------------------------------------------------
function! asclib#preview_tag(tagname)
	if &previewwindow
		return 0
	endif
	let uid = asclib#window_uid('%', '%')
	let pid = asclib#preview_check()
	let opt = {"tagname":""}
	let varname = 'asclib_preview_tag_cache'
	let reuse = 0
	let index = 0
	if pid > 0
		let [l:tabnr, l:winnr] = asclib#window_find(pid)
		let saveopt = gettabwinvar(l:tabnr, l:winnr, varname)
		if type(saveopt) == type({})
			let l:tagname = get(saveopt, 'tagname', '')
			if l:tagname == a:tagname
				let opt = saveopt
				let reuse = 1
			endif
		endif
	endif
	if reuse == 0
		let opt.tagname = a:tagname
		let opt.taglist = asclib#tagfind(a:tagname)
		let opt.index = 0
		if len(opt.taglist) > 0 && pid > 0
			call settabwinvar(l:tabnr, l:winnr, varname, opt)
		endif
	else
		let opt.index += 1
		if opt.index >= len(opt.taglist)
			let opt.index = 0
		endif
	endif
	if len(opt.taglist) == 0 
		call asclib#errmsg('E257: asclib: tag not find "'. a:tagname.'"')
		return 1
	endif
	if opt.index >= len(opt.taglist)
		call asclib#errmsg('E257: asclib: index error')
		return 2
	endif
	let taginfo = opt.taglist[opt.index]
	let filename = taginfo.filename
	if !filereadable(filename)
		call asclib#errmsg('E484: Can not open file '.filename)
		return 3
	endif
	if pid == 0
		let pid = asclib#preview_open()
		let [l:tabnr, l:winnr] = asclib#window_find(pid)
	endif
	call settabwinvar(l:tabnr, l:winnr, varname, opt)
	call asclib#window_goto_uid(uid)
	if 1
		let saveview = winsaveview()
		silent exec 'pedit '.fnameescape(filename)
		call winrestview(saveview)
		call asclib#window_goto_tabwin(l:tabnr, l:winnr)
	else
		call asclib#window_goto_tabwin(l:tabnr, l:winnr)
		silent exec 'e! '.fnameescape(filename)
	endif
	if &previewwindow
		match none
	endif
	if has("folding")
		silent! .foldopen
	endif
	normal! gg
	silent! exec taginfo.cmd
	normal! zz
	if 1
		call search("$", "b")
		call search(escape(a:tagname, '[\*~^'))
		hi previewWord term=bold ctermbg=green ctermfg=black guibg=green guifg=black
		exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
	endif
	call asclib#window_goto_uid(uid)
	let text = taginfo.name
	let text.= ' ('.(opt.index + 1).'/'.len(opt.taglist).') '
	let text.= filename
	call asclib#cmdmsg(text, 1)
endfunc



"----------------------------------------------------------------------
" goto preview file
"----------------------------------------------------------------------
function! asclib#preview_goto(bang)
	let uid = asclib#window_uid('%', '%')
	let pid = asclib#preview_check()
	if pid == 0 || &previewwindow != 0 || uid == pid
		return
	endif
	let [l:tabnr, l:winnr] = asclib#window_find(pid)
	silent! wincmd P
	let l:bufnr = winbufnr(l:winnr)
	let l:line = line('.')
	call asclib#window_goto_uid(uid)
	if l:bufnr != winbufnr('%')
		if a:bang == '' || a:bang == '0'
			silent exec 'b '.l:bufnr 
		else
			silent exec 'b! '.l:bufnr
		endif
	endif
	if winbufnr('%') == l:bufnr
		echo "fuck"
		silent exec ''.l:line
		silent normal zz
	else
		echo "suck"
	endif
endfunc


"----------------------------------------------------------------------
" smooth interface
"----------------------------------------------------------------------
function! s:smooth_scroll(dir, dist, duration, speed)
	for i in range(a:dist/a:speed)
		let start = reltime()
		if a:dir ==# 'd'
			exec 'normal! '. a:speed."\<C-e>".a:speed."j"
		else
			exec 'normal! '. a:speed."\<C-y>".a:speed."k"
		endif
		redraw
		let elapsed = s:get_ms_since(start)
		let snooze = float2nr(a:duration - elapsed)
		if snooze > 0
			exec "sleep ".snooze."m"
		endif
	endfor
endfunc

function! s:get_ms_since(time)
	let cost = split(reltimestr(reltime(a:time)), '\.')
	return str2nr(cost[0]) * 1000 + str2nr(cost[1]) / 1000.0
endfunc

function! asclib#smooth_scroll_up(dist, duration, speed)
	call s:smooth_scroll('u', a:dist, a:duration, a:speed)
endfunc

function! asclib#smooth_scroll_down(dist, duration, speed)
	call s:smooth_scroll('d', a:dist, a:duration, a:speed)
endfunc


