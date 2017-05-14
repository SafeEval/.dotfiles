" Wrapping
setlocal fo+=t         " Ensures wrapping text with textwidth
setlocal textwidth=79  " lines longer than 79 columns will be broken
setlocal tabstop=2     " a hard TAB displays as 2 columns
setlocal softtabstop=2 " insert/delete 2 spaces when hitting a TAB/BACKSPACE
setlocal shiftwidth=2  " operation >> indents 2 columns; << unindents 2 columns
setlocal shiftround    " round indent to multiple of 'shiftwidth'

" Folding
setlocal foldmethod=syntax

" Indentation
setlocal autoindent
setlocal cindent
setlocal smartindent

" Whitespace
autocmd FileType typescript autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileType typescript autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FileType typescript autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd FileType typescript autocmd BufWritePre     * :call TrimWhiteSpace()
