" Custom vim color file - threshold
"
" Find the syntax tag of any text item in a buffer,
" by placing the cursor over it, and hitting F10.
" The function and mapping that does this is at the
" end of this file.
"
" The color values are integers, from 0-254. You can see
" a list of these colors in vim, by running
"       :so ~/.vim/scripts/color_demo.vim
"
" Defined here: http://vim.wikia.com/wiki/Showing_syntax_highlight_group_in_statusline
"
" The syntax definitions can be expanded in this file,
" or via third party plugins.
" - Python Mode: https://github.com/python-mode/python-mode/blob/develop/syntax/python.vim


" Initial settings
let g:colors_name = "threshold"
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif
set t_Co=256


" Normal
hi normal ctermfg=250 ctermbg=NONE cterm=NONE
hi Normal ctermfg=250 ctermbg=NONE cterm=NONE
hi htmlArg ctermfg=250 ctermbg=none cterm=none
hi htmlString ctermfg=250 ctermbg=none cterm=none
hi jsonBraces ctermfg=250 ctermbg=none cterm=none
hi pythonExtraOperator ctermfg=250 ctermbg=NONE cterm=italic
hi typescriptBraces ctermfg=250 ctermbg=none cterm=none
hi typescriptParens ctermfg=250 ctermbg=none cterm=none
hi typescriptOpSymbols ctermfg=250 ctermbg=none cterm=none
hi typescriptLogicSymbols ctermfg=250 ctermbg=none cterm=none


" Comments and Documentation
let s:comment_color = 242
hi Comment ctermfg=242 ctermbg=NONE cterm=italic
hi comment ctermfg=242 ctermbg=NONE cterm=italic
hi pythonDocstring ctermfg=242 ctermbg=NONE cterm=italic


" Functions and Classes
let s:lightblue_color = 14
hi Function ctermfg=14 ctermbg=NONE cterm=NONE
hi jsonBoolean ctermfg=14 ctermbg=none cterm=italic
hi mkdCode ctermfg=6 ctermbg=none cterm=none
hi pythonClass ctermfg=14 ctermbg=NONE cterm=NONE
hi pythonExClass ctermfg=14 ctermbg=NONE cterm=NONE
hi typescriptBrowserObjects ctermfg=14 ctermbg=NONE cterm=italic
hi typescriptHtmlEvents ctermfg=14 ctermbg=NONE cterm=NONE


" Keywords
let s:turqoise_color = 6
hi Statement ctermfg=6 ctermbg=NONE cterm=none
hi statement ctermfg=6 ctermbg=NONE cterm=none
hi htmlTag ctermfg=6 ctermbg=none cterm=none
hi htmlTagName ctermfg=6 ctermbg=none cterm=none
hi pythonRepeat ctermfg=6 ctermbg=none cterm=none
hi pythonSelf ctermfg=6 ctermbg=none cterm=italic
hi pythonNumber ctermfg=6 ctermbg=NONE cterm=italic
hi pythonFloat ctermfg=6 ctermbg=NONE cterm=italic
hi pythonBuiltinFunc ctermfg=6 ctermbg=NONE cterm=NONE
hi pythonBuiltinObj ctermfg=6 ctermbg=none cterm=italic
hi typescriptGlobalObjects ctermfg=6 ctermbg=none cterm=none
hi typescriptHtmlElemProperties ctermfg=6 ctermbg=none cterm=none
hi typescriptPrototype ctermfg=6 ctermbg=none cterm=none
hi typescriptExceptions ctermfg=6 ctermbg=none cterm=none
hi typescriptBoolean ctermfg=6 ctermbg=none cterm=italic
hi typescriptNumber ctermfg=6 ctermbg=NONE cterm=italic
hi typescriptNull ctermfg=6 ctermbg=none cterm=italic
hi typescriptType ctermfg=6 ctermbg=none cterm=italic
hi typescriptIdentifier ctermfg=6 ctermbg=none cterm=italic


" Includes and Preprocessors
let s:include_color = 5  " Purple
hi PreProc ctermfg=5 ctermbg=NONE cterm=NONE
hi Title ctermfg=5 ctermbg=NONE cterm=NONE
hi mkdRule ctermfg=5 ctermbg=NONE cterm=none
hi pythonDecorator ctermfg=5 ctermbg=NONE cterm=italic
hi pythonDottedName ctermfg=5 ctermbg=NONE cterm=italic
hi pythonStrFormat ctermfg=5 ctermbg=NONE cterm=none
hi typescriptDecorators ctermfg=5 ctermbg=NONE cterm=NONE


" Constants and Strings
let s:string_color = 2  " Green
hi Constant ctermfg=2 ctermbg=NONE cterm=NONE
hi constant ctermfg=2 ctermbg=NONE cterm=NONE
hi String ctermfg=2 ctermbg=NONE cterm=italic
hi string ctermfg=2 ctermbg=NONE cterm=italic
hi mkdInlineUrl ctermfg=2 ctermbg=none cterm=italic
hi mkdLink ctermfg=2 ctermbg=none cterm=italic


" Constant Keywords
let contant_color = 136  " Orange


" Vim Features
hi Search ctermfg=238 ctermbg=11 cterm=NONE
hi LineNr ctermfg=242 ctermbg=none cterm=none
hi CursorLineNr ctermfg=3 ctermbg=none cterm=none


" Function to show the syntax highlighting group.
" http://vim.wikia.com/wiki/VimTip99
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
