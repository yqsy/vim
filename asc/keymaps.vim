"======================================================================
"
" keymaps.vim - keymaps start with using <space> 
"
" Created by skywind on 2016/10/12
" Last change: 2016/10/12 16:37:25
"
"======================================================================

"----------------------------------------------------------------------
" VimTools
"----------------------------------------------------------------------
for s:index in range(10)
	exec 'noremap <space>'.s:index.' :VimTool ' . s:index . '<cr>'
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


"----------------------------------------------------------------------
" window control
"----------------------------------------------------------------------
noremap <silent><space>= :resize +3<cr>
noremap <silent><space>- :resize -3<cr>
noremap <silent><space>, :vertical resize -3<cr>
noremap <silent><space>. :vertical resize +3<cr>

nnoremap <silent><c-w><c-e> :Rexplore<cr>
nnoremap <silent><c-w>e :Explore<cr>
nnoremap <silent><c-w>m :Vexplore! 50<cr>
nnoremap <silent><c-w>M :Texplore<cr>

noremap <silent><space>hh :nohl<cr>
noremap <silent><tab>, :call Tab_MoveLeft()<cr>
noremap <silent><tab>. :call Tab_MoveRight()<cr>

noremap <silent><space>ha :GuiSignRemove 
			\ errormarker_error errormarker_warning<cr>

" replace
noremap <space>p viw"0p
noremap <space>y yiw


"----------------------------------------------------------------------
" space + e : vim control
"----------------------------------------------------------------------
noremap <silent><space>eh :call Tools_SwitchSigns()<cr>
noremap <silent><space>en :call Tools_SwitchNumber()<cr>
noremap <silent><space>el :nohl<cr>


"----------------------------------------------------------------------
" gui hotkeys - alt + ?
"----------------------------------------------------------------------
if has('gui_running')
	noremap <M-=> :resize +3<cr>
	noremap <M--> :resize -3<cr>
	noremap <M-,> :vertical resize -3<cr>
	noremap <M-.> :vertical resize +3<cr>
	noremap <silent><A-o> :call Open_Browse(2)<cr>
	inoremap <silent><A-o> <ESC>:call Open_Browse(2)<cr>
	noremap <S-cr> o<ESC>
	noremap <c-cr> O<esc>
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
	noremap <m-_> :call Change_Transparency(-2)<cr>
	noremap <m-+> :call Change_Transparency(+2)<cr>
	if has('gui_macvim')
		noremap <m-\|> :call Toggle_Transparency(9)<cr>
	else
		noremap <m-\|> :call Toggle_Transparency(15)<cr>
	endif
endif


"----------------------------------------------------------------------
" space + s : svn 
"----------------------------------------------------------------------
noremap <space>sc :VimMake svn co -m "update from vim"<cr>
noremap <space>su :VimMake svn up<cr>
noremap <space>st :VimMake svn st<cr>

" editing commands
noremap <space>a ggVG


"----------------------------------------------------------------------
" space + t : toggle plugins
"----------------------------------------------------------------------
noremap <silent><space>tt :TagbarToggle<cr>
noremap <silent><space>tq :call Toggle_QuickFix(6)<cr>
noremap <silent><space>tb :TagbarToggle<cr>

"noremap <silent><C-F10> :call Toggle_Taglist()<cr>
"inoremap <silent><C-F10> <c-\><c-o>:call Toggle_Taglist()<cr>
noremap <silent><S-F10> :call Toggle_Tagbar()<cr>
inoremap <silent><S-F10> <c-\><c-o>:call Toggle_Tagbar()<cr>
noremap <silent><M-;> :call asclib#preview_tag(expand("<cword>"))<cr>
noremap <silent><M-:> :call asclib#preview_close()<cr>
noremap <silent><M-'> :call asclib#preview_goto('')<cr>
noremap <silent><M-"> :call asclib#preview_goto('tab')<cr>

if !has('gui_running')
	exec "set <S-F10>=\e[34~"
	exec "set <S-F4>=\e[25~"
	if !has('nvim')
		exec "set <M-;>=\e]{0};~"
		exec "set <M-'>=\e]{0}'~"
		exec "set <M-:>=\e]{0}:~"
	endif
endif



"----------------------------------------------------------------------
" GUI/Terminal 
"----------------------------------------------------------------------
noremap <silent><M-[> :call Tools_QuickfixCursor(2)<cr>
noremap <silent><M-]> :call Tools_QuickfixCursor(3)<cr>
noremap <silent><M-{> :call Tools_QuickfixCursor(4)<cr>
noremap <silent><M-}> :call Tools_QuickfixCursor(5)<cr>

if (!has('gui_running')) && (!has('nvim'))
	exec "set <m-[>=\e]{0}[~"
	exec "set <m-]>=\e]{0}]~"
	exec "set <m-{>=\e]{0}{~"
	exec "set <m-}>=\e]{0}}~"
endif


"----------------------------------------------------------------------
" space + f : open tools
"----------------------------------------------------------------------
noremap <silent><space>fd :call Open_Dictionary("<C-R>=expand("<cword>")<cr>")<cr>
noremap <silent><space>fm :!man -S 3:2:1 "<C-R>=expand("<cword>")<CR>"<CR>
noremap <silent><space>fh :call Open_HeaderFile(1)<cr>
noremap <silent><space>ff :call Open_Explore(-1)<cr>
noremap <silent><space>ft :call Open_Explore(0)<cr>
noremap <silent><space>fe :call Open_Explore(1)<cr>
noremap <silent><space>fo :call Open_Explore(2)<cr>
noremap <silent><space>fb :TagbarToggle<cr>
noremap <silent><space>fp :call Tools_Pydoc("<C-R>=expand("<cword>")<cr>", 1)<cr>
noremap <silent><space>fs :mksession! ~/.vim/session.txt<cr>
noremap <silent><space>fl :so ~/.vim/session.txt<cr>

set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

for s:index in range(10)
	exec 'noremap <silent><space>f'.s:index.'s :mksession! ~/.vim/session.'.s:index.'<cr>'
	exec 'noremap <silent><space>f'.s:index.'l :so ~/.vim/session.'.s:index.'<cr>'
endfor


"----------------------------------------------------------------------
" leader + b/c : buffer
"----------------------------------------------------------------------
noremap <silent><leader>bc :BufferClose<cr>
noremap <silent><leader>cw :call Change_DirectoryToFile()<cr>


"----------------------------------------------------------------------
" space + h : fast open files
"----------------------------------------------------------------------
noremap <space>hp :tabnew ~/.vim/project.txt<cr>
noremap <space>hf <c-w>gf
noremap <space>he :call Show_Explore()<cr>
noremap <space>hb :tabnew ~/.vim/bundle.vim<cr>
noremap <space>ho :only<cr>

if (!has('nvim')) && (has('win32') || has('win64'))
	noremap <space>hr :tabnew ~/_vimrc<cr>
elseif !has('nvim')
	noremap <space>hr :tabnew ~/.vimrc<cr>
else
	noremap <space>hr :tabnew ~/.config/nvim/init.vim<cr>
endif

let s:filename = expand('<sfile>:p')
exec 'noremap <space>hk :tabnew '.fnameescape(s:filename).'<cr>'
let s:skywind = fnamemodify(s:filename, ':h:h'). '/skywind.vim'
exec 'noremap <space>hs :tabnew '.fnameescape(s:skywind).'<cr>'
let s:bundle = fnamemodify(s:filename, ':h:h'). '/bundle.vim'
exec 'noremap <space>hv :tabnew '.fnameescape(s:bundle).'<cr>'
let s:asclib = fnamemodify(s:filename, ':h:h'). '/autoload/asclib.vim'
exec 'noremap <space>hc :tabnew '.fnameescape(s:asclib).'<cr>'
let s:auxlib = fnamemodify(s:filename, ':h:h'). '/autoload/auxlib.vim'
exec 'noremap <space>hu :tabnew '.fnameescape(s:auxlib).'<cr>'


"----------------------------------------------------------------------
" space + g : misc
"----------------------------------------------------------------------
nnoremap <space>gr :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <space>gq :AsyncStop<cr>
nnoremap <space>gQ :AsyncStop!<cr>
nnoremap <space>gj :%!python -m json.tool<cr>
nnoremap <silent><space>gf :call Tools_QuickfixCursor(3)<cr>
nnoremap <silent><space>gb :call Tools_QuickfixCursor(2)<cr>
nnoremap <silent><space>g; :

noremap <silent><space>g; :call asclib#preview_tag(expand("<cword>"))<cr>
noremap <silent><space>g: :call asclib#preview_close()<cr>
noremap <silent><space>g' :call asclib#preview_goto('')<cr>
noremap <silent><space>g" :call asclib#preview_goto('tab')<cr>

if has('win32') || has('win64')
	noremap <space>gc :silent !start cmd.exe<cr>
	noremap <space>ge :silent !start /b cmd.exe /C start .<cr>
else
endif


"----------------------------------------------------------------------
" linting
"----------------------------------------------------------------------
noremap <silent><space>lp :call asclib#lint_pylint('')<cr>
noremap <silent><space>lf :call asclib#lint_flake8('')<cr>
noremap <silent><space>ls :call asclib#lint_splint('')<cr>
noremap <silent><space>lc :call asclib#lint_cppcheck('')<cr>


"----------------------------------------------------------------------
" more personal in gvim
"----------------------------------------------------------------------
if has('gui_running') && (has('win32') || has('win64'))
	noremap <C-F11> :VimMake -mode=4 -cwd=$(VIM_FILEDIR) pypy "$(VIM_FILENAME)"<cr>
	inoremap <C-F11> <ESC>:VimMake -mode=4 -cwd=$(VIM_FILEDIR) pypy "$(VIM_FILENAME)"<cr>
	noremap <S-F12> :VimMake -mode=4 -cwd=$(VIM_FILEDIR) d:\\dev\\python35\\python.exe "$(VIM_FILENAME)"<cr>
	inoremap <S-F12> <ESC>:VimMake -mode=4 -cwd=$(VIM_FILEDIR) d:\\dev\\python35\\python.exe "$(VIM_FILENAME)"<cr>
endif


if has('gui_running')
	noremap <silent> <m-u> :call asclib#smooth_scroll_up(&scroll, 0, 2)<CR>
	noremap <silent> <m-d> :call asclib#smooth_scroll_down(&scroll, 0, 2)<CR>
	noremap <silent> <m-U> :call asclib#smooth_scroll_up(&scroll * 2, 0, 4)<CR>
	noremap <silent> <m-D> :call asclib#smooth_scroll_down(&scroll * 2, 0, 4)<CR>
endif


