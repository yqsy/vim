function! Python_InitTab()
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal shiftwidth=4
	setlocal noexpandtab
endfunc

if has('autocmd')
	filetype plugin indent on
	autocmd! BufNewFile,BufRead *.py call Python_InitTab()
endif



function! Vim_NeatTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif

		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T'

		" the label is made by MyTabLabel()
		let s .= ' %{Vim_NeatTabLabel(' . (i + 1) . ')} '
	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999XX'
	endif

	return s
endfunc

function! Vim_NeatTabLabel(n)
	let l:buflist = tabpagebuflist(a:n)
	let l:winnr = tabpagewinnr(a:n)
	let l:bufnr = l:buflist[l:winnr - 1]
	let l:name = bufname(l:bufnr)
	if getbufvar(l:bufnr, '&modifiable')
		if l:name == ''
			return '[No Name]'
		else
			return fnamemodify(l:name, ':t')
		endif
	else
		let l:buftype = getbufvar(l:bufnr, '&buftype')
		if l:buftype == 'quickfix'
			return '[Quickfix]'
		elseif l:name != ''
			return '-'.fnamemodify(l:name, ':t')
		else
		endif
		return '[No Name]'
	endif
endfunc



set tabline=%!Vim_NeatTabLine()


