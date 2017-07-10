"======================================================================
"
" quickmenu.vim - 
"
" Created by skywind on 2017/07/08
" Last change: 2017/07/08 23:18:45
"
"======================================================================


"----------------------------------------------------------------------
" Global Options
"----------------------------------------------------------------------
if !exists('g:quickmenu_max_width')
	let g:quickmenu_max_width = 40
endif

if !exists('g:quickmenu_min_width')
	let g:quickmenu_min_width = 15
endif

if !exists('g:quickmenu_disable_nofile')
	let g:quickmenu_disable_nofile = 1
endif

if !exists('g:quickmenu_ft_blacklist')
	let g:quickmenu_ft_blacklist = ['netrw', 'nerdtree']
endif

if !exists('g:quickmenu_padding_left')
	let g:quickmenu_padding_left = '  '
endif


"----------------------------------------------------------------------
" Internal State
"----------------------------------------------------------------------
let s:quickmenu_items = []
let s:quickmenu_name = '[quickmenu]'
let s:quickmenu_last = 0


"----------------------------------------------------------------------
" popup window management
"----------------------------------------------------------------------
function! s:window_exist()
	if !exists('t:quickmenu_bid')
		let t:quickmenu_bid = -1
		return 0
	endif
	return t:quickmenu_bid > 0 && bufexists(t:quickmenu_bid)
endfunc

function! s:window_close()
	if !exists('t:quickmenu_bid')
		return 0
	endif
	if t:quickmenu_bid > 0 && bufexists(t:quickmenu_bid)
		exec 'bwipeout ' . t:quickmenu_bid
		let t:quickmenu_bid = -1
	endif
endfunc

function! s:window_open(size)
	if s:window_exist()
		call s:window_close()
	endif
	let size = a:size
	let size = (size < g:quickmenu_min_width)? g:quickmenu_min_width : size
	let size = (size > g:quickmenu_max_width)? g:quickmenu_max_width : size
	let savebid = bufnr('%')
	exec "silent! ".size.'vne '.s:quickmenu_name
	if savebid == bufnr('%')
		return 0
	endif
	setlocal buftype=nofile bufhidden=wipe nobuflisted nomodifiable
	setlocal noshowcmd noswapfile nowrap nonumber signcolumn=no nospell
	setlocal fdc=0 nolist colorcolumn= nocursorline nocursorcolumn
	setlocal noswapfile norelativenumber
	let t:quickmenu_bid = bufnr('%')
	return 1
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------

function! quickmenu#reset()
	let s:quickmenu_items = []
	let s:quickmenu_last = 0
endfunc

function! quickmenu#append(event, text, ...)
	let filetype = (a:0 >= 1)? a:1 : ''
	let weight = (a:0 >= 2)? a:2 : 0
	let item = {}
	let item.mode = 0
	let item.event = a:event
	let item.text = a:text
	let item.key = ''
	let item.ft = []
	let item.weight = weight
	if a:event
		let item.mode = 0
	if a:text =~ '^#\+\s*'
		let item.mode = 1
		let item.text = matchstr(a:text, '^#\+\s*\zs.*')
	else
		let item.mode = 2
	endif
	for ft in split(filetype, ',')
		let item.ft += [substitute(ft, '^\s*\(.\{-}\)\s*$', '\1', '')]
	endfor
	let index = -1
	let total = len(s:quickmenu_items)
	for i in range(0, total - 1)
		if weight < s:quickmenu_items[i].weight
			let index = i
			break
		endif
	endfor
	if index < 0
		let index = total
	endif
	call insert(s:quickmenu_items, item, index)
	return index
endfunc

function! quickmenu#list()
	for item in s:quickmenu_items
		echo item
	endfor
endfunc




"----------------------------------------------------------------------
" quickmenu interface
"----------------------------------------------------------------------

function! quickmenu#toggle(bang) abort
	if s:window_exist()
		call s:window_close()
		return 0
	endif
	if g:quickmenu_disable_nofile
		if &buftype == 'nofile' || &buftype == 'quickfix'
			return 0
		endif
		if &modifiable == 0
			if index(g:quickmenu_ft_blacklist, &ft) >= 0
				return 0
			endif
		endif
	endif

	" expand menu
	let items = s:select_by_ft(&ft)
	let content = []
	let maxsize = 8
	let hint = '123456789abcdefhlmnopqrstuvwxyz*'
	let index = 0

	for item in s:items
		if item['mode'] == 0
			let item.key = hint[index]
			let index += 1
			if index >= strlen(hint)
				let index = strlen(hint) - 1
			endif
		endif
		let hr = s:menu_expand(item)
		for outline in hr
			let text = outline['text']
			if strlen(text) > maxsize
				let maxsize = strlen(text)
			endif
		endfor
		if len(hr) > 0
			let conent += hr
		endif
	endfor

	let maxsize += strlen(g:quickmenu_padding_left)

	call s:window_open(maxsize)
	call s:window_render(content)

	return 1
endfunc



"----------------------------------------------------------------------
" internals
"----------------------------------------------------------------------

function! s:select_by_ft(ft)
	let items = []
	for item in s:quickmenu_items
		if !item.ft
			let items += [item]
		elseif index(item.ft, a:ft) >= 0
			let items += [item]
		endif
	endfor
	return items
endfunc



function! s:menu_expand(item)
	let content = []
	return content
endfunc


"----------------------------------------------------------------------
" eval & expand: '%{script}' in string
"----------------------------------------------------------------------
function! s:expand_text(string) abort
	let partial = []
	let index = 0
	while 1
		let pos = stridx(a:string, '%{', index)
		if pos < 0
			let partial += [a:string[index:]]
			break
		endif
		let head = ''
		if pos > index
			let partial += [a:string[index:pos - 1]]
		endif
		let endup = stridx(a:string, '}', pos + 2)
		if endup < 0
			let partial += [a:string[index:]]
			break
		endif
		let index = endup + 1
		if endup > pos + 2
			let script = a:string[pos + 2:endup - 1]
			let script = substitute(script, '^\s*\(.\{-}\)\s*$', '\1', '')
			let result = eval(script)
			let partial += [result]
		endif
	endwhile
	return join(partial, '')
endfunc



"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------

if 1

endif


