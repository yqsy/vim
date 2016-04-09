" global settings
let s:winopen = 0
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)
set laststatus=1
set splitright
let g:vimmake_save = 1


" open quickfix
function! Toggle_QuickFix()
	if s:winopen == 0
		exec "copen 6"
		exec "wincmd k"
		set number
		set laststatus=2
		let s:winopen = 2
	elsei s:winopen == 1
		exec "copen 6"
		exec "wincmd k"
		let s:winopen = 2
	else
		exec "cclose"
		let s:winopen = 1
	endif
endfunc

" toggle number
function! Toggle_Number()
	if &number == 0
		set number
	else
		set nonumber
	endif
endfunc

" show content in a new vertical split window
function! s:Show_Content(title, width, content)
	let l:width = a:width
	if l:width == 0
		let l:width = winwidth(0) / 2
		if l:width < 25 | let l:width = 25 | endif
	endif
	exec '' . l:width . 'vnew '. a:title
	setlocal buftype=nofile bufhidden=delete noswapfile winfixwidth
	setlocal noshowcmd nobuflisted wrap nonumber
	if has('syntax')
		sy clear
		sy match ShowCmd /<press q to close>/
		hi clear ShowCmd
		hi def ShowCmd ctermfg=green
	endif
	1s/^/\=a:content/g
	call append(line('.') - 1, '')
	call append(line('.') - 1, '<press q to close>')
	"call append(0, '<press q to close>')
	setlocal nomodifiable
	noremap <silent><buffer> <space> :close!<cr>
	noremap <silent><buffer> <cr> :close!<cr>
	noremap <silent><buffer> <tab> :close!<cr>
	noremap <silent><buffer> q :close!<cr>
	noremap <silent><buffer> c :close!<cr>
endfunc

function! Open_Dictionary(word)
	let l:expl = system('sdcv --utf8-input --utf8-output -n "'. a:word .'"')
	call s:Show_Content('[StarDict]', 28, l:expl)
endfunc

function! Open_Manual(what)
	let l:text = system('man -S 3:2:1 -P cat "'.a:what.'" | col -b')
	call s:Show_Content("[man]", 0, l:text)
	call cursor(1, 1)
endfunc

" switch header
function! Open_HeaderFile(where)
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
			if a:where == 0
				exec 'e '.fnameescape(l:newname)
			elseif a:where == 1
				exec 'vs ' . fnameescape(l:newname)
			else
				exec 'tabedit '. fnameescape(l:newname)
			endif
			return
		endif
	endfor
	echo 'switch failed, can not find another part of c/c++ source'
endfunc

" Open Explore in new tab with current directory
function! Open_Explore(where)
	let l:path = expand("%:p:h")
	if l:path == ''
		let l:path = getcwd()
	endif
	if a:where == 0
		exec 'Explore '.fnameescape(l:path)
	elseif a:where == 1
		exec 'vnew'
		exec 'Explore '.fnameescape(l:path)
	else
		exec 'tabnew'
		exec 'Explore '.fnameescape(l:path)
	endif
endfunc

function! Open_BrowseInTab()
	let l:path = expand("%:p:h")
	if l:path == '' | let l:path = getcwd() | endif
	exec 'browse tabnew '.fnameescape(l:path)
endfunc

" delete buffer keep window
function! s:BufferClose(bang, buffer)
	let l:bufcount = bufnr('$')
	let l:switch = 0 	" window which contains target buffer will be switched
	if empty(a:buffer)
		let l:target = bufnr('%')
	elseif a:buffer =~ '^\d\+$'
		let l:target = bufnr(str2nr(a:buffer))
	else
		let l:target = bufnr(a:buffer)
	endif
	if l:target <= 0
		echohl ErrorMsg
		echomsg "cannot find buffer: '" . a:buffer . "'"
		echohl NONE
		return 0
	endif
	if !getbufvar(l:target, "&modifiable")
		echohl ErrorMsg
		echomsg "Cannot close a non-modifiable buffer"
		echohl NONE
		return 0
	endif
	if empty(a:bang) && getbufvar(l:target, '&modified')
		echohl ErrorMsg
		echomsg "No write since last change (use :BufferClose!)"
		echohl NONE
		return 0
	endif
	if bufnr('#') > 0	" check alternative buffer
		let l:aid = bufnr('#')
		if l:aid != l:target && buflisted(l:aid) && getbufvar(l:aid, "&modifiable")
			let l:switch = l:aid	" switch to alternative buffer
		endif
	endif
	if l:switch == 0	" check non-scratch buffers
		let l:index = l:bufcount
		while l:index >= 0
			if buflisted(l:index) && getbufvar(l:index, "&modifiable")
				if strlen(bufname(l:index)) > 0 && l:index != l:target
					let l:switch = l:index	" switch to that buffer
					break
				endif
			endif
			let l:index = l:index - 1	
		endwhile
	endif
	if l:switch == 0	" check scratch buffers
		let l:index = l:bufcount
		while l:index >= 0
			if buflisted(l:index) && getbufvar(l:index, "&modifiable")
				if l:index != l:target
					let l:switch = l:index	" switch to a scratch
					break
				endif
			endif
			let l:index = l:index - 1
		endwhile
	endif
	if l:switch  == 0	" check if only one scratch left
		if strlen(bufname(l:target)) == 0 && (!getbufvar(l:target, "&modified"))
			echo "This is the last scratch" 
			return 0
		endif
	endif
	let l:ntabs = tabpagenr('$')
	let l:tabcc = tabpagenr()
	let l:wincc = winnr()
	let l:index = 1
	while l:index <= l:ntabs
		exec 'tabn '.l:index
		while 1
			let l:wid = bufwinnr(l:target)
			if l:wid <= 0 | break | endif
			exec l:wid.'wincmd w'
			if l:switch == 0
				exec 'enew!'
				let l:switch = bufnr('%')
			else
				exec 'buffer '.l:switch
			endif
		endwhile
		let l:index += 1
	endwhile
	exec 'tabn ' . l:tabcc
	exec l:wincc . 'wincmd w'
	exec 'bdelete! '.l:target
	return 1
endfunction

command! -bang -nargs=? BufferClose call s:BufferClose('<bang>', '<args>')






