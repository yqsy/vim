"======================================================================
"
" asckit.vim - autoload methods
"
" Created by skywind on 2016/10/28
" Last change: 2016/10/28 00:38:10
"
"======================================================================


"----------------------------------------------------------------------
" basic interface
"----------------------------------------------------------------------

if !exists('g:rootmarkers')
  let g:asc_rootmarkers = ['.projectroot', '.git', '.hg', '.svn', '.bzr']
  let g:asc_rootmarkers += ['_darcs', 'build.xml']
endif

function! s:getfullname(f)
  let f = a:f
  if f =~ "'."
	  try
		  redir => m
		  silent exe ':marks' f[1]
		  redir END
		  let f = split(split(m, '\n')[-1])[-1]
		  let f = filereadable(f)? f : ''
	  catch
		  let f = ''
	  endtry
  endif
  let f = len(f) ? f : expand('%')
  return fnamemodify(f, ':p')
endfunc


" asckit#findroot([file]): get the project root (if any) {{{1
function! asckit#findroot(...)
	let fullfile = s:getfullname(a:0 ? a:1 : '')
	if exists('b:projectroot')
		if stridx(fullfile, fnamemodify(b:projectroot, ':p')) == 0
			return b:projectroot
		endif
	endif
	if fullfile =~ '^fugitive:/'
		if exists('b:git_dir')
			return fnamemodify(b:git_dir, ':h')
		endif
		return '' " skip any fugitive buffers early
	endif
	for marker in g:asc_rootmarkers
		let pivot=fullfile
		while 1
			let prev = pivot
			let pivot = fnamemodify(pivot, ':h')
			if filereadable(pivot.'/'.marker)
				return pivot
			elseif isdirectory(pivot.'/'.marker)
				return pivot
			endif
			if pivot == prev
				break
			endif
		endwhile
	endfor
	return ''
endfunc


" guess file root
function! asckit#guessroot(...)
	let projroot = asckit#findroot(a:0 ? a:1 : '')
	if len(projroot)
		return projroot
	endif
	" Not found: return parent directory of current file / file itself.
	let fullfile = s:getfullname(a:0 ? a:1 : '')
	return !isdirectory(fullfile) ? fnamemodify(fullfile, ':h') : fullfile
endfunc


"----------------------------------------------------------------------
" update root tags
"----------------------------------------------------------------------
function! asckit#root_update_tags(ctags, cscope)
endfunc



