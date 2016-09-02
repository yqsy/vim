" global settings
let s:winopen = 0
let g:status_var = ""
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)
set splitright
set switchbuf=useopen,usetab,newtab
"set splitbelow
let g:vimmake_save = 1


" open quickfix
function! Toggle_QuickFix(size)
	function! s:WindowCheck(mode)
		if getbufvar('%', '&buftype') == 'quickfix'
			let s:quickfix_open = 1
			return
		endif
		if a:mode == 0
			let w:quickfix_pos1 = getcurpos()
			normal! H
			let w:quickfix_pos2 = getcurpos()
		else
			call setpos('.', w:quickfix_pos2)
			call setpos('.', w:quickfix_pos1)
		endif
	endfunc
	let s:quickfix_open = 0
	let l:winnr = winnr()			
	windo call s:WindowCheck(0)
	if s:quickfix_open == 0
		exec 'botright copen '.a:size
		wincmd k
	else
		cclose
	endif
	windo call s:WindowCheck(1)
	silent exec ''.l:winnr.'wincmd w'
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
	exec '' . l:width . 'vnew '. fnameescape(a:title)
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

" Open file in new tab if it hasn't been open, or reuse the existant tab
function! Tools_FileSwitch(how, filename)
	let l:tabcc = tabpagenr()
	let l:wincc = winnr()
	let l:filename = fnamemodify(a:filename, ':p')
	if has('win32') || has('win16') || has('win64') || has('win95')
		let l:filename = tolower(l:filename)
	endif
	for i in range(tabpagenr('$'))
		silent exec 'tabn '.(i + 1)
		let l:buflist = tabpagebuflist(i + 1)
		for j in range(len(l:buflist))
			let l:bufnr = l:buflist[j]
			if !getbufvar(l:bufnr, '&modifiable')
				continue
			endif
			let l:buftype = getbufvar(l:bufnr, '&buftype')
			if l:buftype == 'quickfix'
				continue
			endif
			let l:name = fnamemodify(bufname(l:bufnr), ':p')
			if has('win32') || has('win16') || has('win64') || has('win95')
				let l:name = tolower(l:name)
			endif
			if l:filename == l:name
				silent exec ''.(j + 1).'wincmd w'
				return
			endif
		endfor
	endfor
	silent exec 'tabn '.l:tabcc
	silent exec ''.l:wincc.'wincmd w'
	if (a:how == 'edit') || (a:how == 'e')
		exec 'e '.fnameescape(a:filename)
	elseif (a:how == 'tabedit') || (a:how == 'tabe') || (a:how == 'tabnew')
		exec 'tabe '.fnameescape(a:filename)
	elseif (a:how == 'split') || (a:how == 'sp')
		exec 'split '.fnameescape(a:filename)
	elseif (a:how == 'vsplit') || (a:how == 'vs')
		exec 'vsplit '.fnameescape(a:filename)
	else
		echohl ErrorMsg
		echom "unknow command: ".a:how
		echohl NONE
	endif
endfunc

command! -nargs=* FileSwitch call Tools_FileSwitch(<f-args>)



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
				call Tools_FileSwitch('e', l:newname)
			elseif a:where == 1
				call Tools_FileSwitch('vs', l:newname)
			else
				call Tools_FileSwitch('tabnew', l:newname)
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

function! Open_Browse(where)
	let l:path = expand("%:p:h")
	if l:path == '' | let l:path = getcwd() | endif
	if exists('g:browsefilter') && exists('b:browsefilter')
		if g:browsefilter != ''
			let b:browsefilter = g:browsefilter
		endif
	endif
	if a:where == 0
		exec 'browse e '.fnameescape(l:path)
	elseif a:where == 1
		exec 'browse vnew '.fnameescape(l:path)
	else
		exec 'browse tabnew '.fnameescape(l:path)
	endif
endfunc

function! Change_Transparency(increase)
	if a:increase < 0
		let l:inc = -a:increase
		if l:inc > &transparency
			set transparency=0
		else
			let &transparency = &transparency - l:inc
		endif
	elseif a:increase > 0
		let l:inc = a:increase
		if l:inc + &transparency > 100
			set transparency=100
		else
			let &transparency = &transparency + l:inc
		endif
	endif
	echo 'transparency: '.&transparency
endfunc

function! Toggle_Transparency(value)
	if &transparency > 0
		set transparency=0
	else
		let &transparency = a:value
	endif
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

function! Change_DirectoryToFile()
	let l:filename = expand("%:p")
	if l:filename == "" | return | endif
	silent exec 'cd '.expand("%:p:h")
	exec 'pwd'
endfunc


" quickfix
let g:status_var = ""
augroup QuickfixStatus
	au! BufWinEnter quickfix setlocal 
		\ statusline=%t\ [%{g:vimmake_build_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
augroup END


" log file
function! s:LogAppend(filename, text)
	let l:ts = strftime("[%Y-%m-%d %H:%M:%S] ")
	exec "redir >> ".fnameescape(a:filename)
	silent echon l:ts.a:text."\n"
	silent exec "redir END"
endfunc


" write a log
function! LogWrite(text)
	if !exists('s:logname')
		let s:logname = expand("~/.vim/tmp/record.log")
		let l:path = expand("~/.vim/tmp")
		try
			silent call mkdir(l:path, "p", 0755)
		catch /^Vim\%((\a\+)\)\=:E/
		finally
		endtry
	endif
	try
		call s:LogAppend(s:logname, a:text)
	catch /^Vim\%((\a\+)\)\=:E/
	finally
	endtry
endfunc


" toggle taglist
function! Toggle_Taglist()
	call LogWrite('[taglist] '.expand("%:p"))
	silent exec 'TlistToggle'
endfunc


" toggle tagbar
function! Toggle_Tagbar()
	call LogWrite('[tagbar] '.expand("%:p"))
	silent exec 'TagbarToggle'
endfunc


" open explorer/finder
function! Show_Explore()
	let l:locate = expand("%:p:h")
	if has('win32') || has('win64') || has('win16')
		exec "!start /b cmd.exe /C explorer.exe ".shellescape(l:locate)
	endif
endfunc

" CTRL-N -> TAB
function! Tools_Tab2CN(enable)
	if a:enable == 0
		iunmap <TAB>
	else
		inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<tab>"
	endif
endfunc

" Search pydoc
function! Tools_Pydoc(word, where)
	let l:text = system('python -m pydoc ' . shellescape(a:word))
	if a:where == '0' || a:where == 'quickfix'
		cexpr l:text
	else
		call s:Show_Content('PyDoc: '.a:word, 0, l:text)
	endif
endfunc


command! -nargs=1 PyDoc call Tools_Pydoc("<args>", '1')


function! Tools_BellUnix()
    let l:t_ti = &t_ti
    let l:t_te = &t_te
    let &t_ti = ""
    let &t_te = ""
    silent !printf "\a"
    redraw!
    let &t_ti = l:t_ti
    let &t_te = l:t_te
endfunc

function! Tools_BellConflict()
	silent exec 'norm! \<ESC>'
endfunc

function! Tools_SwitchLayout() 
	set number
    set showtabline=2
    set laststatus=2
	if !has('gui_running')
		set t_Co=256
		set ttimeoutlen=100
	endif
	if $SSH_CONNECTION != ''
		let g:vimmake_build_bell = 1
		let g:asyncrun_bell = 1
	endif
endfunc



