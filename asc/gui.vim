if !has('gui_running')
	finish
endif


"----------------------------------------------------------------------
"- Quickfix Chinese Convertion
"----------------------------------------------------------------------
function! QuickfixChineseConvert()
   let qflist = getqflist()
   for i in qflist
	  let i.text = iconv(i.text, "gbk", "utf-8")
   endfor
   call setqflist(qflist)
endfunction


"----------------------------------------------------------------------
"- FontBoldOff
"----------------------------------------------------------------------
function! s:FontBoldOff()
	let hid = 1
	while 1
		let hln = synIDattr(hid, 'name')
		if !hlexists(hln) | break | endif
		if hid == synIDtrans(hid) && synIDattr(hid, 'bold')
			let atr = ['underline', 'undercurl', 'reverse', 'inverse', 'italic', 'standout']
			call filter(atr, 'synIDattr(hid, v:val)')
			let gui = empty(atr) ? 'NONE' : join(atr, ',')
			exec 'highlight ' . hln . ' gui=' . gui
		endif
		let hid += 1
	endwhile
endfunc

command! FontBoldOff call s:BoldOff()


"----------------------------------------------------------------------
"- GUI Setting
"----------------------------------------------------------------------
function! s:GuiTheme(theme)
	if type(a:theme) == 0
		let l:theme = string(a:theme)
	else
		let l:theme = a:theme
	endif
	if l:theme == '0'
		set guifont=inconsolata:h11
		color desert256
		highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE 
			\ gui=NONE guifg=DarkGrey guibg=NONE
	elseif l:theme == '1'
		set guifont=inconsolata:h11
		color seoul256
	elseif l:theme == '2'
		set guifont=fixedsys:h10
		color seoul256
		FontBoldOff
	endif
endfunc

command! -nargs=1 GuiTheme call s:GuiTheme(<f-args>)


"----------------------------------------------------------------------
"- GUI Setting
"----------------------------------------------------------------------
if has('gui_running')
	set guioptions-=L
	set mouse=a
	set showtabline=2
	set laststatus=2
	set number
	set t_Co=256
	if has('win32') || has('win64') || has('win16') || has('win95')
		language messages en
		set langmenu=en_US
		set guifont=inconsolata:h11
		"set guifont=fixedsys
		au QuickfixCmdPost make call QuickfixChineseConvert()
		let g:config_vim_gui_label = 3
		"color desert256
		color seoul256
		set guioptions-=t
		set guioptions=egrmT
	elseif has('gui_macvim')
		color seoul256
		set guioptions=egrm
	endif
	highlight Pmenu guibg=darkgrey guifg=black
else
	set t_Co=256 t_md=
endif


"----------------------------------------------------------------------
"- Menu Setting
"----------------------------------------------------------------------
amenu B&uild.&Run<TAB>F5 :VimExecute run<cr>
amenu B&uild.E&xecute<TAB>F6 :VimExecute filename<cr>
amenu B&uild.-s1- :
amenu B&uild.&Gcc<TAB>F9 :VimMake gcc<cr>
amenu B&uild.&Emake<Tab>F7 :VimMake emake<cr>
amenu B&uild.GNU\ &Make :VimMake make<cr>
amenu B&uild.-s2- :
amenu B&uild.User\ Tool\ 1 :VimTool 1<cr>
amenu B&uild.User\ Tool\ 2 :VimTool 2<cr>
amenu B&uild.User\ Tool\ 3 :VimTool 3<cr>
amenu B&uild.User\ Tool\ 4 :VimTool 4<cr>
amenu B&uild.User\ Tool\ 5 :VimTool 5<cr>
amenu B&uild.User\ Tool\ 6 :VimTool 6<cr>
amenu B&uild.User\ Tool\ 7 :VimTool 7<cr>
amenu B&uild.User\ Tool\ 8 :VimTool 8<cr>
amenu B&uild.User\ Tool\ 9 :VimTool 9<cr>
amenu B&uild.User\ Tool\ 0 :VimTool 0<cr>

amenu PopUp.-s9- :
amenu PopUp.Open\ &Header :call Open_HeaderFile(2)<cr>
amenu PopUp.-s10- :
amenu PopUp.Search\ &Symbol :VimScope s <C-R>=expand("<cword>")<CR><CR>
amenu PopUp.Search\ &Defininition :VimScope g <C-R>=expand("<cword>")<CR><CR>
amenu PopUp.Functions\ &Called by :VimScope d <C-R>=expand("<cword>")<CR><CR>
amenu PopUp.Functions\ &Calling :VimScope c <C-R>=expand("<cword>")<CR><CR>
amenu PopUp.Search\ &String :VimScope t <C-R>=expand("<cword>")<CR><CR>
amenu PopUp.Search\ &Pattern :VimScope e <C-R>=expand("<cword>")<CR><CR>
amenu PopUp.Search\ &File :VimScope f <C-R>=expand("<cword>")<CR><CR>
amenu PopUp.Search\ &Include :VimScope i <C-R>=expand("<cword>")<CR><CR>



