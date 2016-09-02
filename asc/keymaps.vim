" keymaps is more personality with using <space> leader
for s:index in range(10)
	let s:key = '' . s:index
	exec 'noremap <space>'.s:key.' :VimTool ' . s:key . '<cr>'
	if has('gui_running')
		let s:button = 'F'.s:index
		if s:index == 0 | let s:button = 'F10' | endif
		exec 'noremap <S-'.s:button.'> :VimTool '. s:key .'<cr>'
		exec 'inoremap <S-'.s:button.'> <ESC>:VimTool '. s:key .'<cr>'
	endif
endfor

noremap <F1> :VimTool 1<cr>
noremap <F2> :VimTool 2<cr>
noremap <F3> :VimTool 3<cr>
noremap <F4> :VimTool 4<cr>
inoremap <F1> <ESC>:VimTool 1<cr>
inoremap <F2> <ESC>:VimTool 2<cr>
inoremap <F3> <ESC>:VimTool 3<cr>
inoremap <F4> <ESC>:VimTool 4<cr>


" keymap for VimTool
if has('gui_running') && (has('win32') || has('win64'))
	let s:keys = [')', '!', '@', '#', '$', '%', '^', '&', '*', '(']
	for s:index in range(10)
		let s:name = ''.s:index
		if s:index == 0 | let s:name = '10' | endif
		exec 'noremap <silent><M-'.s:keys[s:index].'> :VimTool '.s:index.'<cr>'
		exec 'inoremap <silent><M-'.s:keys[s:index].'> <ESC>:VimTool '.s:index.'<cr>'
	endfor
else
	" require to config terminal to remap key alt-shift+? to '\033[{0}?~'
	for s:index in range(10)
		let s:name = ''.s:index
		if s:index == 0 | let s:name = '10' | endif
	endfor
endif


" window resizing shortcuts
noremap <silent><space>= :resize +3<cr>
noremap <silent><space>- :resize -3<cr>
noremap <silent><space>, :vertical resize -3<cr>
noremap <silent><space>. :vertical rexize +3<cr>
noremap <silent><space>hh :nohl<cr>
noremap <silent><tab>, :call Tab_MoveLeft()<cr>
noremap <silent><tab>. :call Tab_MoveRight()<cr>

" replace
noremap <space>p viw"0p
noremap <space>y yiw

if has('gui_running')
	noremap <M-=> :resize +3<cr>
	noremap <M--> :resize -3<cr>
	noremap <M-,> :vertical resize -3<cr>
	noremap <M-.> :vertical resize +3<cr>
	noremap <silent><A-o> :call Open_Browse(2)<cr>
	inoremap <silent><A-o> <ESC>:call Open_Browse(2)<cr>
	noremap <S-cr> o<ESC>
	noremap <M-l> w
	noremap <M-h> b
	noremap <M-j> 10j
	noremap <M-k> 10k
	vnoremap <M-c> "+y
	noremap <M-V> "+P
	noremap <M-v> "+p
	noremap <M-p> "0p
	noremap <C-S> :w<cr>
	inoremap <C-S> <ESC>:w<cr>
	noremap <M-Left> :call Tab_MoveLeft()<cr>
	noremap <M-Right> :call Tab_MoveRight()<cr>
	inoremap <M-Left> <ESC>:call Tab_MoveLeft()<cr>
	inoremap <M-Right> <ESC>:call Tab_MoveRight()<cr>
	noremap <M-r> :VimExecute run<cr>
	inoremap <M-r> <ESC>:VimExecute run<cr>
	noremap <M-b> :VimBuild emake<cr>
	inoremap <M-b> <ESC>:VimBuild emake<cr>
	noremap <M-f> <c-w>gf:call Change_DirectoryToFile()<cr>
	inoremap <M-f> <ESC><c-w>gf:call Change_DirectoryToFile()<cr>
	noremap <M-a> ggVG
	inoremap <M-a> <ESC>ggVG
	if has('gui_macvim')
		noremap <M-_> :call Change_Transparency(-2)<cr>
		noremap <M-+> :call Change_Transparency(+2)<cr>
		noremap <M-F4> :call Toggle_Transparency(8)<cr>
	endif
endif


" svn shortcut
noremap <space>sc :!svn co -m "update from vim"<cr>
noremap <space>su :!svn up<cr>
noremap <space>st :!svn st<cr>

" editing commands
noremap <space>a ggVG

" toggle plugins
noremap <silent><space>tt :TagbarToggle<cr>
noremap <silent><space>tq :call Toggle_QuickFix(6)<cr>
noremap <silent><S-F10> :call Toggle_Taglist()<cr>
inoremap <silent><S-F10> <c-\><c-o>:call Toggle_Taglist()<cr>
noremap <silent><C-F10> :call Toggle_Tagbar()<cr>
inoremap <silent><C-F10> <c-\><c-o>:call Toggle_Tagbar()<cr>
noremap <silent><space>tn :call Toggle_Number()<cr>
noremap <silent><space>tb :TagbarToggle<cr>

if !has('gui_running')
	exec "set <S-F10>=\e[34~"
endif

" open tools
noremap <silent><space>fd :call Open_Dictionary("<C-R>=expand("<cword>")<cr>")<cr>
noremap <silent><space>fm :!man -S 3:2:1 "<C-R>=expand("<cword>")<CR>"<CR>
noremap <silent><space>fh :call Open_HeaderFile(1)<cr>
noremap <silent><space>ft :call Open_Explore(0)<cr>
noremap <silent><space>fe :call Open_Explore(1)<cr>
noremap <silent><space>fo :call Open_Explore(2)<cr>
noremap <silent><space>fb :TagbarToggle<cr>
noremap <silent><space>fp :call Tools_Pydoc("<C-R>=expand("<cword>")<cr>", 1)<cr>

noremap <silent><leader>e :BufferClose<cr>
noremap <silent><leader>cw :call Change_DirectoryToFile()<cr>

" fast open file
if has('win32') || has('win64')
noremap <space>hr :tabnew ~/_vimrc<cr>
else
noremap <space>hr :tabnew ~/.vimrc<cr>
endif

let s:filename = expand('<sfile>:p')
exec 'noremap <space>hk :tabnew '.s:filename.'<cr>'
let s:skywind = fnamemodify(s:filename, ':h:h'). '/skywind.vim'
exec 'noremap <space>hs :tabnew '.s:skywind.'<cr>'
noremap <space>hp :tabnew ~/.vim/project.txt<cr>
noremap <space>hf <c-w>gf
noremap <space>he :call Show_Explore()<cr>
noremap <space>hb :tabnew ~/.vim/bundle.vim<cr>
noremap <space>ho :only<cr>

" cscope in new tab
noremap <space>cs :scs find s <C-R>=expand("<cword>")<CR><CR>
noremap <space>cg :scs find g <C-R>=expand("<cword>")<CR><CR>
noremap <space>cc :scs find c <C-R>=expand("<cword>")<CR><CR>
noremap <space>ct :scs find t <C-R>=expand("<cword>")<CR><CR>
noremap <space>ce :scs find e <C-R>=expand("<cword>")<CR><CR>
noremap <space>cf :scs find f <C-R>=expand("<cword>")<CR><CR>
noremap <space>ci :scs find i <C-R>=expand("<cword>")<CR><CR>
noremap <space>cd :scs find d <C-R>=expand("<cword>")<CR><CR>


