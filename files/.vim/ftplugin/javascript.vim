setlocal fo+=t         " Ensures wrapping text with textwidth
setlocal textwidth=79  " lines longer than 79 columns will be broken
setlocal tabstop=2     " a hard TAB displays as 2 columns
setlocal softtabstop=2 " insert/delete 2 spaces when hitting a TAB/BACKSPACE
setlocal shiftwidth=2  " operation >> indents 2 columns; << unindents 2 columns
setlocal shiftround    " round indent to multiple of 'shiftwidth'
setlocal autoindent    " align the new line indent with the previous line
setlocal nosmartindent " Set for vim 7+

" Lines with same indent form a fold
setlocal foldmethod=syntax

" Trim whitespace on write
autocmd FileType javascript autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileType javascript autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FileType javascript autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd FileType javascript autocmd BufWritePre     * :call TrimWhiteSpace()
