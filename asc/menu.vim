"======================================================================
"
" menu.vim - 
"
" Created by skywind on 2017/07/06
" Last change: 2017/07/06 16:59:26
"
"======================================================================



"----------------------------------------------------------------------
" internal help
"----------------------------------------------------------------------

function! menu#FindInProject()
	let p = vimmake#get_root('%')
	let t = expand('<cword>')
	echohl Type
	call inputsave()
	let t = input('find word ('. p.'): ', t)
	call inputrestore()
	echohl None
	if strlen(t) > 0
		silent exec "GrepCode! ".fnameescape(t)
	endif
endfunc

function! menu#CodeCheck()
	if &ft == 'python'
		call asclib#lint_pylint('')
	elseif &ft == 'c' || &ft == 'cpp'
		call asclib#lint_cppcheck('')
	else
		call asclib#errmsg('file type unsupported, only support python/c/cpp')
	endif
endfunc

function! menu#DelimitSwitch(on)
	if a:on
		exec "DelimitMateOn"
	else
		exec "DelimitMateOff"
	endif
endfunc

function! menu#TogglePaste()
	if &paste
		set nopaste
	else
		set paste
	endif
endfunc

function! menu#CurrentWord(limit)
	let text = expand('<cword>')
	if len(text) < a:limit
		return text
	endif
	return text[:a:limit] . '..'
endfunc

function! menu#CurrentFile(limit)
	let text = expand('%:t')
	if len(text) < a:limit
		return text
	endif
	return text[:a:limit] . '..'
endfunc


"----------------------------------------------------------------------
" menu initialize
"----------------------------------------------------------------------

let g:quickmenu_options = 'LH'

call quickmenu#reset()

call quickmenu#append('# Find', '')

call quickmenu#append('Find "%{menu#CurrentWord(12)}"', 'call menu#FindInProject()', '当前工程目录中（离当前文档最近的包含 .svn/.git/.root的上级目录）搜索光标下的单词')

call quickmenu#append('Stop searching', 'VimStop', '停止上面的搜索')

call quickmenu#append('Tag view "%{menu#CurrentWord(10)}"', 'call asclib#preview_tag(expand("<cword>"))', '在右边显示符号预览，有多处定义的话，执行一次切换一次')

call quickmenu#append('Tag update', 'call vimmake#update_tags("!", "ctags", ".tags")', '扫描更新当前工程目录的 ctags 符号索引')


call quickmenu#append('# Debug', '')

call quickmenu#append('Run "%{menu#CurrentFile(12)}"', 'VimExecute run', '按扩展名运行当前文件')

call quickmenu#append('Compile "%{menu#CurrentFile(12)}"', 'VimBuild gcc', '使用 gcc 编译当前文件')

call quickmenu#append('Code static check', 'call menu#CodeCheck()', '使用 pycheck, flake, cppcheck 等工具进行源代码静态检查')

call quickmenu#append('# SVN', '')

call quickmenu#append("svn diff", 'call asclib#svn_diff("%")', '提交前的修改版本对比，使用 "]c" 和 "[c" 查找下一处和上一处改动，二次运行关闭对比')

call quickmenu#append("svn log", 'VimMake! -raw svn log %', '查看当前文件的修改日志，在 Quickfix窗口中显示结果，按F10可以隐藏/切换 Quickfix')

call quickmenu#append('# Settings', '')

call quickmenu#append('Set paste %{&paste? "[x]" :"[ ]"}', 'call menu#TogglePaste()', '切换粘贴模式')


