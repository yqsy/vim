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
		au QuickfixCmdPost make call QuickfixChineseConvert()
		let g:config_vim_gui_label = 3
		color desert256
		set guioptions-=t
		set guioptions=egrmT
	elseif has('gui_macvim')
		color seoul256
		set guioptions=egrm
	endif
	highlight Pmenu guibg=darkgrey guifg=black
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




