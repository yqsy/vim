if exists('b:current_syntax')
endif

let s:padding_left = get(g:, 'quickmenu_padding_left', '   ')

syntax sync fromstart

execute 'syntax match QuickmenuBracket /.*\%'. (len(s:padding_left) + 6) .'c/ contains=
      \ QuickmenuNumber,
      \ QuickmenuSelect'

syntax match QuickmenuNumber  /^\s*\[\zs[^BSVT]\{-}\ze\]/
syntax match QuickmenuSelect  /^\s*\[\zs[BSVT]\{-}\ze\]/
syntax match QuickmenuSpecial /\V<close>\|<quit>/


if exists('b:quickmenu.section_lines')
	for line in b:quickmenu.section_lines
		exec 'syntax region QuickmenuSection start=/\%'. line .'l/ end=/$/'
	endfor
endif

if exists('b:quickmenu.text_lines')
	for line in b:quickmenu.text_lines
		exec 'syntax region QuickmenuText start=/\%'. line .'l/ end=/$/'
	endfor
endif

if exists('b:quickmenu.header_lines')
	for line in b:quickmenu.header_lines
		exec 'syntax region QuickmenuHeader start=/\%'. line .'l/ end=/$/'
	endfor
endif

if v:version < 508
	command! -nargs=+ HiLink hi! link <args>
else
	command! -nargs=+ HiLink hi! def link <args>
endif


HiLink  QuickMenuSelection	ErrorMsg
" HiLink  QuickMenuBracketL   String
" HiLink  QuickMenuBracketR   String

HiLink	QuickmenuBracket		Delimiter
HiLink	QuickmenuSection		Statement
HiLink	QuickmenuSelect			Title
HiLink	QuickmenuNumber			Number
HiLink	QuickmenuSpecial		Comment
HiLink	QuickmenuHeader			Title


