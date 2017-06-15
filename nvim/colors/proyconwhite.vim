" Vim color file
" Original Maintainer:  Lars H. Nielsen (dengmao@gmail.com)
" Last Change:  2010-07-23
"
" Modified version of wombat for 256-color terminals by
"   David Liang (bmdavll@gmail.com)
" based on version by
"   Danila Bespalov (danila.bespalov@gmail.com)

set background=light

if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

let colors_name = "proyconwhite"


" General colors
hi Normal		ctermfg=252		ctermbg=234		cterm=none		guifg=#111111	guibg=#f1eee9	gui=none
hi Cursor		ctermfg=234		ctermbg=228		cterm=none		guifg=#f1eee9	guibg=#837f18	gui=none
hi Visual		ctermfg=251		ctermbg=239		cterm=none		guifg=#000000	guibg=#c3c6ca	gui=none
hi VisualNOS	ctermfg=251		ctermbg=236		cterm=none		guifg=#303030	guibg=#c3c6ca	gui=none
hi Search		ctermfg=177		ctermbg=241		cterm=none		guifg=#f0ff90	guibg=#d787ff	gui=none
hi Folded		ctermfg=103		ctermbg=237		cterm=none		guifg=#3a4046   guibg=#a0a8b0	gui=none
hi Title		ctermfg=230						cterm=bold		guifg=#837f18					gui=bold
hi StatusLine	ctermfg=230		ctermbg=238		cterm=none		guifg=#837f18	guibg=#444444	gui=italic
hi VertSplit	ctermfg=238		ctermbg=238		cterm=none		guifg=#444444	guibg=#444444	gui=none
hi StatusLineNC	ctermfg=241		ctermbg=238		cterm=none		guifg=#857b6f	guibg=#444444	gui=none
hi LineNr		ctermfg=241		ctermbg=232		cterm=none		guifg=#857b6f	guibg=#080808	gui=none
hi SpecialKey	ctermfg=241		ctermbg=235		cterm=none		guifg=#626262	guibg=#2b2b2b	gui=none
hi WarningMsg	ctermfg=203										guifg=#ff5f55
hi ErrorMsg		ctermfg=196		ctermbg=236		cterm=bold		guifg=#ff2026	guibg=#aaaaaa	gui=bold

" Vim >= 7.0 specific colors
if version >= 700
hi CursorLine					ctermbg=236		cterm=none						guibg=#dddddd
hi MatchParen	ctermfg=228		ctermbg=101		cterm=bold		guifg=#eae788	guibg=#857b6f	gui=bold
hi Pmenu		ctermfg=230		ctermbg=238						guifg=#444444	guibg=#fffd74
hi PmenuSel		ctermfg=232		ctermbg=192						guifg=#cae982	guibg=#080808
endif

" Diff highlighting
hi DiffAdd						ctermbg=17										guibg=#2a0d6a
hi DiffDelete	ctermfg=234		ctermbg=60		cterm=none		guifg=#f1eee9	guibg=#3e3969	gui=none
hi DiffText						ctermbg=53		cterm=none						guibg=#73186e	gui=none
hi DiffChange					ctermbg=237										guibg=#382a37

"hi CursorIM
"hi Directory
"hi IncSearch
"hi Menu
"hi ModeMsg
"hi MoreMsg
"hi PmenuSbar
"hi PmenuThumb
"hi Question
"hi Scrollbar
"hi SignColumn
"hi SpellBad
"hi SpellCap
"hi SpellLocal
"hi SpellRare
"hi TabLine
"hi TabLineFill
"hi TabLineSel
"hi Tooltip
"hi User1
"hi User9
"hi WildMenu


" Syntax highlighting
hi Keyword		ctermfg=111		cterm=none		guifg=#1354a4	gui=bold
hi Statement	ctermfg=111		cterm=none		guifg=#1354a4	gui=bold
hi Operator		ctermfg=117		cterm=none		guifg=#0f7465	gui=bold
hi Constant		ctermfg=173		cterm=none		guifg=#d02918	gui=none
hi PreProc		ctermfg=173		cterm=none		guifg=#e5786d	gui=bold
hi Function		ctermfg=212		cterm=none		guifg=#a02074	gui=none
hi Identifier	ctermfg=192		cterm=none		guifg=#0f7465	gui=bold
hi Structure	ctermfg=192		cterm=none		guifg=#0f7465	gui=none
hi Type			ctermfg=186		cterm=none		guifg=#7c5629	gui=bold
hi Special		ctermfg=229		cterm=none		guifg=#a08000	gui=none
hi String		ctermfg=113		cterm=none		guifg=#9b0977	gui=italic
hi Comment		ctermfg=246		cterm=none		guifg=#877741	gui=italic
hi Todo			ctermfg=160		cterm=none		guifg=#856f8e	gui=italic


" Links
hi! link FoldColumn		Folded
hi! link CursorColumn	CursorLine
hi! link NonText		LineNr

" vim:set ts=4 sw=4 noet:
