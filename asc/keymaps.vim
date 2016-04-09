" keymaps is more personality with using <space> leader
for s:index in range(10)
	let s:key = '' . s:index
	if s:index == 10 | let s:key = '0' | endif
	exec 'noremap <space>'.s:key.' :VimTool ' . s:key . '<cr>'
endfor

" keymap for VimTool in windows gvim
if has('gui_running') && (has('win32') || has('win64'))
	let s:keys = [')', '!', '@', '#', '$', '%', '^', '&', '*', '(']
	for s:index in range(10)
		exec 'noremap <silent><A-'.s:keys[s:index].'> :VimTool '.s:index.'<cr>'
		exec 'inoremap <silent><A-'.s:keys[s:index].'> <ESC>:VimTool '.s:index.'<cr>'
	endfor
else
	let s:keys = ['º', '¡', '™', '£', '¢', '∞', '§', '¶', '•', 'ª', 'º' ]
endif

" keymap for VimTool in macvim
if has('gui_macvim')
	noremap <silent><D-O> :browse tabedit<cr>
	for s:index in range(10)
		let s:key = ''. s:index
		if s:index == 10 | let s:key = '0' | endif
		exec 'noremap <A-'.s:key.'> :VimTool '.s:key.'<cr>'
		exec 'inoremap <A-'.s:key.'> <ESC>:VimTool '.s:key.'<cr>'
	endfor
endif

" window resizing shortcuts
noremap <space>= :resize +3<cr>
noremap <space>- :resize -3<cr>
noremap <space>, :vertical resize -3<cr>
noremap <space>. :vertical rexize +3<cr>

if has('gui_running')
	noremap <M-=> :resize +3<cr>
	noremap <M--> :resize -3<cr>
	noremap <M-,> :vertical resize -3<cr>
	noremap <M-.> :vertical resize +3<cr>
	noremap <M-w> :tabclose<cr>
	inoremap <M-w> <ESC>:tabclose<cr>
	noremap <silent><A-o> :call Open_BrowseInTab()<cr>
	inoremap <silent><A-o> <ESC>:call Open_BrowseInTab()<cr>
	noremap <M-s> :w<cr>
	inoremap <M-s> <esc>:w<cr>
	noremap <M-s> :w<cr>
	inoremap <M-s> <esc>:w<cr>

	noremap <S-cr> o<ESC>
else
	
endif


" svn shortcut
noremap <space>sc :!svn co -m "update from vim"<cr>
noremap <space>su :!svn up<cr>
noremap <space>st :!svn st<cr>

" toggle plugins
noremap <space>tt :TagbarToggle<cr>
noremap <space>tq :call Toggle_QuickFix()<cr>
noremap <silent><F10> :call Toggle_QuickFix()<cr>
inoremap <silent><F10> <C-o>:call Toggle_QuickFix()<cr>
noremap <space>tn :call Toggle_Number()<cr>

" open tools
noremap <silent><space>fd :call Open_Dictionary("<C-R>=expand("<cword>")<cr>")<cr>
noremap <silent><space>fm :!man -S 3:2:1 "<C-R>=expand("<cword>")<CR>"<CR>
noremap <silent><space>fh :call Open_HeaderFile()<cr>
noremap <silent><space>fe :call Open_ExploreInRight()<cr>
noremap <silent><space>fo :call Open_ExploreInTab()<cr>
noremap <silent><space>ft :call Open_ExploreHere()<cr>


noremap <silent><leader>e :BufferClose<cr>

" fast open file
if has('win32') || has('win64')
	noremap <space>hr :tabnew ~/_vimrc<cr>
else
	noremap <space>hr :tabnew ~/.vimrc<cr>
endif



