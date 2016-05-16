if !exists('s:vimasc_home')
	let s:vimasc_home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
	exec 'set rtp+='.s:vimasc_home
endif

function! s:IncScript(name)
	exec 'so 's:vimasc_home.'/'.a:name
endfunc

command! -nargs=1 IncScript call s:IncScript('<args>')

IncScript asc/viminit.vim
IncScript asc/vimmake.vim

IncScript asc/config.vim
IncScript asc/backup.vim

if has('python') && has('timers')
	IncScript asc/build.vim
	" IncScript asc/build2.vim
endif

IncScript asc/ignores.vim
IncScript asc/tools.vim
IncScript asc/keymaps.vim
IncScript asc/plugins.vim

IncScript asc/misc.vim


MakeKeymap


