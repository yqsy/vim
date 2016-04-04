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
function! Open_HeaderFile()
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



