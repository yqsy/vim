let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 IncScript exec 'so '.s:home.'/'.'<args>'
exec 'set rtp+='.s:home

IncScript asc/viminit.vim
IncScript asc/vimmake.vim

MakeKeymap

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




