
" ======================================
"            Initialize
" ======================================

" vi improved only
set nocompatible



" ======================================
"         Interface
" ======================================

let mapleader=","

" One less key to hit for commands
nnoremap ; :

" Insert spaces when hitting TABs
set expandtab

" Turn help to escape, no accidental hit
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>



" ======================================
"             Appearance
" ======================================

" Enable 256 colors. Good for statusbar.
set t_Co=256

" Show status even without a split
set laststatus=2

" Font selection
set guifont=courier_new

" Colorscheme selection
colorscheme delek

" Enable sytax highlighting
syntax on

" Absolute line numbering
set number

" Underline current line
set cursorline

" Highlight matching brackets
set showmatch

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/



" ======================================
"              Navigation
" ======================================

" Easier split nagivation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quick vertical split, then switch to new split.
nnoremap <leader>w <C-w>v<C-w>l

" Unmap arrow keys, no crutch
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>



" ======================================
"              Search
" ======================================

" Incremental searches, refined while typing
set incsearch

" Highlight search result
set hlsearch

" Clear the distracting search highlighting
nnoremap <leader><space> :noh<cr>

" Ignore these file types when searching
set wildignore+=*/tmp/*,*.so,*.swp,*.zip



" ======================================
"            Code Folding
" ======================================

" Initialize all folds
set foldlevel=99  " All open
"set foldlevel=0   " All closed

" space bar folds
nnoremap <space> za

" Fold highlights
highlight Folded ctermfg=DarkBlue ctermbg=Black



" ======================================
"            File Operations
" ======================================

" Use unix line breaks
set fileformat=unix

" Undo enabled, even after closing (.un~)
set undofile



" ======================================
"           Functions
" ======================================

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

" Fix following a symlink when opening a file (ctrlp issue)
" http://inlehmansterms.net/2014/09/04/sane-vim-working-directories/
" --------------------------------------------------------
"
" follow symlinked file
function! FollowSymlink()
  let current_file = expand('%:p')
  " check if file type is a symlink
  if getftype(current_file) == 'link'
    " if it is a symlink resolve to the actual file path
    "   and open the actual file
    let actual_file = resolve(current_file)
    silent! execute 'file ' . actual_file
  end
endfunction


" Set cwd to directory of npm, if npm project
" or working directory to git project root
" or directory of current file, if not git project
function! SetProjectRoot()

  " default to the current file's directory
  lcd %:p:h
  let current_dir = getcwd()

  " Look for npm on the system
  let npm_present = system("whereis npm | cut -d: -f2 | tr -d '\n'")
  if !empty(npm_present)
    let npm_dir = system("npm bin | sed 's/\\/node_modules\\/\.bin//g' | tr -d '[\n]'")
    let has_node_dir = system("ls | grep node_modules")

    " if cwd has node_modules, stay put
    if !empty(has_node_dir)
      return 0
    endif

    " if a place besides cwd has node_modules, go there
    if (npm_dir != current_dir)
      lcd `=npm_dir`
      return 0
    endif
  endif

  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let git_dir = system("git rev-parse --show-toplevel")
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if empty(is_not_git_dir)
    lcd `=git_dir`
  endif

endfunction

" follow symlink and set working directory
autocmd BufRead *
  \ call FollowSymlink()
  \ | call SetProjectRoot()



" ======================================
"            Plugins
" ======================================

" Load vim-plug if not installed
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif


filetype off                  " Disable filetype recognition
call plug#begin()


" Useful hotkeys and commands
" ---------------------------
Plug 'tpope/vim-unimpaired'  " yo for paste mode
Plug 'tpope/vim-abolish'     " :S for smart substitution
Plug 'tpope/vim-surround'    " ysiw<div> surround in <div> tags
                             " ds{ delete surrounding {}
                             " cs( change surrounding to ()
Plug 'tpope/vim-commentary'  " gc to comment/uncomment lines
autocmd FileType cfg setlocal commentstring=#\ %s
autocmd FileType sls setlocal commentstring=#\ %s

" -------------------
" Navigation
" -------------------

" ctrlp for fuzzy search
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git',
                          \ 'cd %s && git ls-files --exclude-standard -co',
                          \ 'find %s -type f']  " Fallback to find

" NerdTree for file system browser
Plug 'scrooloose/nerdtree'
" Easy toggle of navigation pane
map <C-n> :NERDTreeToggle<CR>



" ---------------
" Git integration
" ---------------
Plug 'tpope/vim-fugitive'
" Shows git diff info in the gutter
Plug 'airblade/vim-gitgutter'
" Check for git diffs every X ms
set updatetime=1000



" ---------------------
" Lightweight statusbar
" ---------------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
" Default theme
let g:airline_theme = 'term'
" Enable enhanced fonts with unicode
let g:airline_powerline_fonts = 1
" Enable tagbar integration
let g:airline#extensions#tagbar#enabled = 1
" Enable virtualenv integration
let g:airline#extensions#virtualenv#enabled = 1


" ----------------------
" Interface enhancements
" ----------------------
Plug 'Yggdroot/indentLine'


" -------------
" Language tags
" -------------
" TODO: look at the universal-ctags plugin
Plug 'majutsushi/tagbar'
" Toggle the tagbar
nnoremap <leader>t :TagbarToggle<CR>
nmap <leader>t :TagbarToggle<CR>



" ------------------------------
" Code completion and generation
" ------------------------------

" TODO: look at vimcompleteme as an alternative
Plug 'ajh17/VimCompletesMe'

" YouCompleteMe code completion
"Plug 'Valloric/YouCompleteMe'  " LARGE download (~200MB)
let g:ycm_autoclose_preview_window_after_completion=1

" supertab lets YCM and snippets not trip over each other.
" make YCM compatible with UltiSnips (using supertab)
Plug 'ervandew/supertab'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'


" Snippet engine and library
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" Where to find custom snippets, including custom ones
let g:UltiSnipsSnippetDirectories=["UltiSnips", "vimsnips"]



" -------------------------
" Syntax checking (linting)
" -------------------------
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_error_symbol = '❌'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_style_warning_symbol = '💩'
highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn



" --------------
" Python support
" --------------
Plug 'klen/python-mode'  " Python super plugin (lint, refactor, doc, +++)
let python_highlight_all = 1
let g:pymode_rope = 0  " Disable rope

" Python virtualenv support
Plug 'jmcantrell/vim-virtualenv'

" Python linting
let g:syntastic_python_python_exec = '/usr/bin/env python' " default to py3
let g:syntastic_python_checkers = ['pylint'] " python linting from python-mode

" Python code folding
Plug 'tmhedberg/SimpylFold'
let g:SimpylFold_docstring_preview = 0  " Don't fold docstrings and imports
let g:SimpylFold_fold_import = 0



" ------------------
" Javascript support
" ------------------
Plug 'pangloss/vim-javascript'

" linting
let g:syntastic_javascript_checkers = ['eslint']
Plug 'mtscout6/syntastic-local-eslint.vim' " Use local project's eslint.



" -----------------
" React/JSX support
" -----------------
Plug 'mxw/vim-jsx'
" JSX only in files with .jsx extension.
let g:jsx_ext_required = 1



" ------------------
" TypeScript support
" ------------------
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
Plug 'leafgarland/typescript-vim'  " highlight/indent
" TODO: make linting/loading quicker
"Plug 'Shougo/vimproc.vim'  " tsuquyomi dep. Requires make.
"Plug 'Quramy/tsuquyomi'
"let g:tsuquyomi_disable_quickfix = 1
"let g:syntastic_typescript_checkers = ['tsuquyomi'] " !tslint
let g:syntastic_typescript_checkers = ['tslint'] " !tsuquyomi



" ---------------
" Angular support
" ---------------

" Ignore some HTML linting rules with angular
" TODO: conditionally apply this if an ng tag is present.
let g:syntastic_html_tidy_ignore_errors=[' proprietary attribute ',
  \ 'trimming empty <',
  \ 'unescaped &',
  \ 'lacks "action',
  \ 'is not recognized!',
  \ 'discarding unexpected',
  \ ' lacks value',
  \ ' is invalid']



" ------------
" HTML support
" ------------
let g:syntastic_html_tidy_exec = 'tidy'



" -------------
" Jinja support
" -------------
Plug 'lepture/vim-jinja'



" --------------------------------
" Salt Stack SLS support
" --------------------------------
Plug 'saltstack/salt-vim'



call plug#end()
filetype plugin indent on     " Enable filetype recognition
