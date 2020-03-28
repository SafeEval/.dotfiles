setlocal fo+=t         " Ensures wrapping text with textwidth
setlocal textwidth=79  " lines longer than 79 columns will be broken
setlocal tabstop=4     " a hard TAB displays as 4 columns
setlocal softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
setlocal shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
setlocal shiftround    " round indent to multiple of 'shiftwidth'
setlocal autoindent    " align the new line indent with the previous line
setlocal nosmartindent " Set for vim 7+
setlocal encoding=utf-8  " UTF-8 encoding
