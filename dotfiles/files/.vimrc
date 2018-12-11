
" ======================================
"            Initialize
" ======================================

" vi improved only
set nocompatible
set encoding=utf-8


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

" Enable sytax highlighting
syntax on

" Show status even without a split
set laststatus=2

" Font selection
set guifont=courier_new

" Absolute line numbering
set number

" Underline current line
set cursorline

" Highlight matching brackets
set showmatch

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
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
"highlight Folded ctermfg=DarkBlue ctermbg=Black



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


" F10: Show syntax highlighting group under cursor.
" http://vim.wikia.com/wiki/VimTip99
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>



" ======================================
"            Plugins
" ======================================

" Load vim-plug if not installed
" https://github.com/junegunn/vim-plug#post-update-hooks
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif


filetype off                  " Disable filetype recognition
call plug#begin()


" ------------------------------
" Useful text editing commands
" ------------------------------
Plug 'tpope/vim-unimpaired'  " yo for paste mode
Plug 'tpope/vim-abolish'     " :S for smart substitution
Plug 'tpope/vim-surround'    " ysiw<div> surround in <div> tags
                             " ds{ delete surrounding {}
                             " cs( change surrounding to ()
Plug 'tpope/vim-commentary'  " gc to comment/uncomment lines
autocmd FileType cfg setlocal commentstring=#\ %s
autocmd FileType sls setlocal commentstring=#\ %s



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



" -------------
" Language tags
" -------------

" Universal CTags: code tag generation.
" Requires `autoreconf` or `dh-autoreconf` system package to be installed for compilation.
" https://askubuntu.com/questions/796408/installing-and-using-universal-ctags-instead-of-exuberant-ctags#836521
" https://stackoverflow.com/questions/25819649/how-to-exclude-multiple-directories-with-exuberant-ctags#25819720
Plug 'universal-ctags/ctags', { 
                        \'dir': '~/.ctags', 
                        \'do': './autogen.sh; ./configure --prefix=$HOME; make',
                        \}


" Autotag: automatically regenerate tags for a file when written.
Plug 'craigemery/vim-autotag'

" Tagbar: List of tags in current file, bird's eye view.
" Requires ctags for tag generation
Plug 'majutsushi/tagbar'
" TypeScript support for Tagbar.
" https://github.com/majutsushi/tagbar/wiki#exuberant-ctags-vanilla
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }

" Markdown support for Tagbar.
" https://github.com/majutsushi/tagbar/wiki#markdown
Plug 'jszakmeister/markdown2ctags'
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" Tagbar hotkeys
nnoremap <C-y> :TagbarToggle<CR>
nmap <C-y> :TagbarToggle<CR>



" ----------
" Navigation
" ----------

" FZF: fuzzy file search
" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run install script
" https://github.com/junegunn/fzf/wiki/Examples-(vim)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }


" Use the correct file source, based on context
function! ContextualFZF()
    " Determine if inside a git repo
    silent exec "!git rev-parse --show-toplevel"
    redraw!

    if v:shell_error
        " Search in current directory
        call fzf#run({
          \'sink': 'e',
          \'down': '40%',
        \})
    else
        " Search in entire git repo
        call fzf#run({
          \'sink': 'e',
          \'down': '40%',
          \'source': 'git ls-tree --full-tree --name-only -r HEAD',
        \})
    endif
endfunction
map <C-p> :call ContextualFZF()<CR>


" Configure FZF to find ctags
" https://github.com/junegunn/fzf/wiki/Examples-(vim)#jump-to-tags
function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction
function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R --exclude=.git --exclude=node_modules --html-kinds=-ij')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction
command! Tags call s:tags()
nnoremap <C-t> :Tags<CR>
nmap <C-t> :Tags<CR>


" NerdTree: file system browser
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>



" ---------------
" Git integration
" ---------------
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'  " Shows git diff info in the gutter
set updatetime=1000  " Check for git diffs every X ms



" ----------------------
" Interface enhancements
" ----------------------
Plug 'Yggdroot/indentLine'



" -------------------------
" Syntax checking (linting)
" -------------------------

" Spellchecking text in file types.
" https://vi.stackexchange.com/questions/6950/how-to-enable-spell-check-for-certain-file-types
augroup markdownSpell
    autocmd!
    autocmd FileType markdown setlocal spell
    autocmd BufRead,BufNewFile *.md setlocal spell
augroup END
augroup textSpell
    autocmd!
    autocmd FileType text setlocal spell
    autocmd BufRead,BufNewFile *.txt setlocal spell
augroup END


" ALE (async lint engine)
Plug 'w0rp/ale'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_linters = {
\   'markdown': ['alex', 'markdownlint'],
\}

" Python
" https://blog.landscape.io/using-pylint-on-django-projects-with-pylint-django.html
let g:ale_python_pylint_options = '--load-plugins pylint_django'

" JavaScript
" let g:syntastic_javascript_checkers = ['eslint']
" Plug 'mtscout6/syntastic-local-eslint.vim' " Use local project's eslint.

" TypeScript
"Plug 'Shougo/vimproc.vim'  " tsuquyomi dep. Requires make.
"Plug 'Quramy/tsuquyomi'
"let g:tsuquyomi_disable_quickfix = 1
"let g:tsuquyomi_completion_detail = 0  " Makes completion slow.
"nnoremap <leader>d :TsuDefinition<CR>
"nmap <leader>d :TsuDefinition<CR>
"nnoremap <leader>b :TsuGoBack<CR>
"nmap <leader>b :TsuGoBack<CR>
"nnoremap <leader>r :TsuReferences<CR>
"nmap <leader>r :TsuReferences<CR>

"let g:syntastic_typescript_checkers = ['tsuquyomi'] " !tslint
" let g:syntastic_typescript_checkers = ['tslint'] " !tsuquyomi
" Ignore some HTML linting rules with angular
" TODO: conditionally apply this if an ng tag is present.
" let g:syntastic_html_tidy_ignore_errors=[' proprietary attribute ',
  " \ 'trimming empty <',
  " \ 'unescaped &',
  " \ 'lacks "action',
  " \ 'is not recognized!',
  " \ 'discarding unexpected',
  " \ ' lacks value',
  " \ ' is invalid']

" HTML
" let g:syntastic_html_tidy_exec = 'tidy'


" --------------
" Python support
" --------------

Plug 'jmcantrell/vim-virtualenv' " Python virtualenv support
Plug 'tmhedberg/SimpylFold'  " Python specific code folding
let g:SimpylFold_docstring_preview = 0  " Don't fold docstrings and imports
let g:SimpylFold_fold_import = 0



" ---------------------
" Status bar
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



" --------------------------------------
" Syntax definitions (for highlighting)
" --------------------------------------

Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['python']  " Handled by python-mode
let g:polyglot_disabled += ['html']  " Handled by python-mode
" Plug 'leafgarland/typescript-vim'  " Handled by vim-polyglot
" Plug 'lepture/vim-jinja'  " Handled by vim-polyglot
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 1 " Only interpret *.jsx
Plug 'saltstack/salt-vim'

" Python syntax file (for highlighting).
" Also installs redundant features, which are disabled.
Plug 'python-mode/python-mode'
let g:pymode_python = 'python3'
let g:pymode_lint = 0  " ALE
let g:pymode_folding = 0  " SimplyFold
let g:pymode_run = 0
let g:pymode_breakpoint = 0
let g:pymode_options = 0
let g:pymode_doc = 0
let g:pymode_rope = 0
let g:pymode_debug = 0



" ---------------------
" Color scheme
" ---------------------

colorscheme threshold  " Custom colorscheme file

"Plug 'flazz/vim-colorschemes'
" colorscheme 0x7A69_dark
" colorscheme 1989
" colorscheme 256-grayvim
" colorscheme 256-jungle
" colorscheme 256_noir
" colorscheme 3dglasses
" colorscheme Benokai
" colorscheme Black
" colorscheme BlackSea
" colorscheme Blue2
" colorscheme C64
" colorscheme CandyPaper
" colorscheme Chasing_Logic
" colorscheme ChocolateLiquor
" colorscheme ChocolatePapaya
" colorscheme CodeFactoryv3
" colorscheme Dark
" colorscheme Dark2
" colorscheme DarkDefault
" colorscheme DevC++
" colorscheme Dev_Delight
" colorscheme Dim
" colorscheme Dim2
" colorscheme DimBlue
" colorscheme DimGreen
" colorscheme DimGreens
" colorscheme DimGrey
" colorscheme DimRed
" colorscheme DimSlate
" colorscheme Green
" colorscheme Light
" colorscheme LightDefault
" colorscheme LightDefaultGrey
" colorscheme LightTan
" colorscheme LightYellow
" colorscheme Monokai
" colorscheme MountainDew
" colorscheme OceanicNext
" colorscheme PapayaWhip
" colorscheme PaperColor
" colorscheme Red
" colorscheme Revolution
" colorscheme Slate
" colorscheme SlateDark
" colorscheme Spink
" colorscheme SweetCandy
" colorscheme Tomorrow-Night-Blue
" colorscheme Tomorrow-Night-Bright
" colorscheme Tomorrow-Night-Eighties
" colorscheme Tomorrow-Night
" colorscheme Tomorrow
" colorscheme VIvid
" colorscheme White2
" colorscheme abbott
" colorscheme abra
" colorscheme adam
" colorscheme adaryn
" colorscheme adobe
" colorscheme adrian
" colorscheme advantage
" colorscheme af
" colorscheme aiseered
" colorscheme alduin
" colorscheme anderson
" colorscheme anotherdark
" colorscheme ansi_blows
" colorscheme antares
" colorscheme apprentice
" colorscheme aqua
" colorscheme argonaut
" colorscheme ashen
" colorscheme asmanian2
" colorscheme asmanian_blood
" colorscheme asmdev
" colorscheme asmdev2
" colorscheme astronaut
" colorscheme asu1dark
" colorscheme atom
" colorscheme aurora
" colorscheme automation
" colorscheme autumn
" colorscheme autumnleaf
" colorscheme babymate256
" colorscheme badwolf
" colorscheme bandit
" colorscheme base
" colorscheme base16-ateliercave
" colorscheme base16-atelierdune
" colorscheme base16-atelierestuary
" colorscheme base16-atelierforest
" colorscheme base16-atelierheath
" colorscheme base16-atelierlakeside
" colorscheme base16-atelierplateau
" colorscheme base16-ateliersavanna
" colorscheme base16-atelierseaside
" colorscheme base16-ateliersulphurpool
" colorscheme base16-railscasts
" colorscheme basic
" colorscheme bayQua
" colorscheme baycomb
" colorscheme bclear
" colorscheme beachcomber
" colorscheme beauty256
" colorscheme beekai
" colorscheme behelit
" colorscheme benlight
" colorscheme bensday
" colorscheme billw
" colorscheme biogoo
" colorscheme birds-of-paradise
" colorscheme black_angus
" colorscheme blackbeauty
" colorscheme blackboard
" colorscheme blackdust
" colorscheme blacklight
" colorscheme blaquemagick
" colorscheme blazer
" colorscheme blink
" colorscheme blue
" colorscheme bluechia
" colorscheme bluedrake
" colorscheme bluegreen
" colorscheme blueprint
" colorscheme blueshift
" colorscheme bluez
" colorscheme blugrine
" colorscheme bmichaelsen
" colorscheme bocau
" colorscheme bog
" colorscheme borland
" colorscheme breeze
" colorscheme brogrammer
" colorscheme brookstream
" colorscheme brown
" colorscheme bubblegum-256-dark
" colorscheme bubblegum-256-light
" colorscheme bubblegum
" colorscheme buddy
" colorscheme burnttoast256
" colorscheme busierbee
" colorscheme busybee
" colorscheme buttercream
" colorscheme bvemu
" colorscheme bw
" colorscheme c
" colorscheme c16gui
" colorscheme cabin  " Nice
" colorscheme cake
" colorscheme cake16
" colorscheme calmar256-dark
" colorscheme calmar256-light
" colorscheme camo
" colorscheme campfire
" colorscheme candy
" colorscheme candycode
" colorscheme candyman
" colorscheme caramel
" colorscheme carrot
" colorscheme carvedwood
" colorscheme carvedwoodcool
" colorscheme cascadia
" colorscheme cgpro
" colorscheme chance-of-storm
" colorscheme charged-256
" colorscheme charon
" colorscheme chela_light
" colorscheme chlordane
" colorscheme chocolate
" colorscheme chrysoprase
" colorscheme clarity
" colorscheme cleanphp
" colorscheme cleanroom
" colorscheme clearance
" colorscheme cloudy
" colorscheme clue
" colorscheme cobalt
" colorscheme cobalt2
" colorscheme cobaltish
" colorscheme coda
" colorscheme codeblocks_dark
" colorscheme codeburn
" colorscheme codeschool
" colorscheme coffee
" colorscheme coldgreen
" colorscheme colorer
" colorscheme colorful
" colorscheme colorful256
" colorscheme colorsbox-faff
" colorscheme colorsbox-greenish
" colorscheme colorsbox-material
" colorscheme colorsbox-stblue
" colorscheme colorsbox-stbright
" colorscheme colorsbox-steighties
" colorscheme colorsbox-stnight
" colorscheme colorzone
" colorscheme contrasty
" colorscheme cool
" colorscheme corn
" colorscheme corporation
" colorscheme crayon
" colorscheme crt
" colorscheme cthulhian
" colorscheme custom
" colorscheme d8g_01
" colorscheme d8g_02
" colorscheme d8g_03
" colorscheme d8g_04
" colorscheme dante
" colorscheme dark-ruby
" colorscheme darkBlue
" colorscheme darkZ
" colorscheme darkblack
" colorscheme darkblue
" colorscheme darkblue2
" colorscheme darkbone
" colorscheme darkburn
" colorscheme darkdevel
" colorscheme darkdot
" colorscheme darkeclipse
" colorscheme darker-robin
" colorscheme darkerdesert
" colorscheme darkocean
" colorscheme darkrobot
" colorscheme darkslategray
" colorscheme darkspectrum
" colorscheme darktango
" colorscheme darkzen
" colorscheme darth
" colorscheme dawn
" colorscheme deepsea
" colorscheme default
" colorscheme delek  " Nice
" colorscheme delphi
" colorscheme denim
" colorscheme derefined
" colorscheme desert
" colorscheme desert256
" colorscheme desert256v2
" colorscheme desertEx
" colorscheme desertedocean
" colorscheme desertedoceanburnt
" colorscheme desertink
" colorscheme detailed
" colorscheme devbox-dark-256
" colorscheme deveiate
" colorscheme developer
" colorscheme disciple
" colorscheme distinguished
" colorscheme django
" colorscheme donbass
" colorscheme doorhinge
" colorscheme doriath
" colorscheme dracula  " Nice
" colorscheme dual
" colorscheme dull
" colorscheme duotone-dark
" colorscheme duotone-darkcave
" colorscheme duotone-darkdesert
" colorscheme duotone-darkearth
" colorscheme duotone-darkforest
" colorscheme duotone-darkheath
" colorscheme duotone-darklake
" colorscheme duotone-darkmeadow
" colorscheme duotone-darkpark
" colorscheme duotone-darkpool
" colorscheme duotone-darksea
" colorscheme duotone-darkspace
" colorscheme dusk
" colorscheme dw_blue
" colorscheme dw_cyan
" colorscheme dw_green
" colorscheme dw_orange
" colorscheme dw_purple
" colorscheme dw_red
" colorscheme dw_yellow
" colorscheme earendel
" colorscheme earth
" colorscheme earthburn
" colorscheme eclipse
" colorscheme eclm_wombat
" colorscheme ecostation
" colorscheme editplus
" colorscheme edo_sea
" colorscheme ego
" colorscheme ekinivim
" colorscheme ekvoli
" colorscheme elda
" colorscheme elflord
" colorscheme elise
" colorscheme elisex
" colorscheme elrodeo
" colorscheme elrond
" colorscheme emacs
" colorscheme enigma
" colorscheme enzyme
" colorscheme erez
" colorscheme eva
" colorscheme eva01
" colorscheme evening
" colorscheme evening1
" colorscheme evolution
" colorscheme far
" colorscheme felipec
" colorscheme feral
" colorscheme flatcolor
" colorscheme flatland
" colorscheme flatlandia
" colorscheme flattened_dark
" colorscheme flattened_light
" colorscheme flattown
" colorscheme flattr
" colorscheme flatui
" colorscheme fnaqevan
" colorscheme fog
" colorscheme fokus
" colorscheme forneus
" colorscheme freya
" colorscheme frood
" colorscheme frozen
" colorscheme fruidle
" colorscheme fruit
" colorscheme fruity
" colorscheme fu
" colorscheme fx
" colorscheme gardener
" colorscheme gemcolors
" colorscheme genericdc-light
" colorscheme genericdc
" colorscheme gentooish
" colorscheme getafe
" colorscheme getfresh
" colorscheme github
" colorscheme gobo
" colorscheme golded
" colorscheme golden
" colorscheme goodwolf
" colorscheme google
" colorscheme gor
" colorscheme gotham
" colorscheme gotham256
" colorscheme gothic
" colorscheme grape
" colorscheme gravity
" colorscheme grayorange
" colorscheme graywh
" colorscheme grb256
" colorscheme greens
" colorscheme greenvision
" colorscheme grey2
" colorscheme greyblue
" colorscheme grishin
" colorscheme gruvbox
" colorscheme gryffin
" colorscheme guardian
" colorscheme guepardo
" colorscheme h80
" colorscheme habiLight
" colorscheme harlequin
" colorscheme heliotrope
" colorscheme hemisu
" colorscheme herald
" colorscheme heroku-terminal  " Nice
" colorscheme heroku
" colorscheme herokudoc-gvim
" colorscheme herokudoc
" colorscheme hhazure
" colorscheme hhdblue
" colorscheme hhdcyan
" colorscheme hhdgray
" colorscheme hhdgreen
" colorscheme hhdmagenta
" colorscheme hhdred
" colorscheme hhdyellow
" colorscheme hhorange
" colorscheme hhpink
" colorscheme hhspring
" colorscheme hhteal
" colorscheme hhviolet
" colorscheme hilal
" colorscheme holokai
" colorscheme hornet
" colorscheme hotpot
" colorscheme hybrid-light
" colorscheme hybrid
" colorscheme hybrid_material
" colorscheme hybrid_reverse
" colorscheme iangenzo
" colorscheme ibmedit
" colorscheme icansee
" colorscheme iceberg
" colorscheme impact
" colorscheme impactG
" colorscheme impactjs
" colorscheme industrial
" colorscheme industry
" colorscheme ingretu
" colorscheme inkpot
" colorscheme inori
" colorscheme ir_black
" colorscheme ironman
" colorscheme itg_flat
" colorscheme jaime
" colorscheme jammy
" colorscheme janah
" colorscheme jelleybeans
" colorscheme jellybeans
" colorscheme jellyx
" colorscheme jhdark
" colorscheme jhlight
" colorscheme jiks
" colorscheme kalahari
" colorscheme kalisi
" colorscheme kalt
" colorscheme kaltex
" colorscheme kate
" colorscheme kellys
" colorscheme khaki
" colorscheme kib_darktango
" colorscheme kib_plastic
" colorscheme kiss
" colorscheme kkruby
" colorscheme koehler
" colorscheme kolor
" colorscheme kruby
" colorscheme kyle
" colorscheme laederon
" colorscheme landscape
" colorscheme lanzarotta
" colorscheme lapis256
" colorscheme last256
" colorscheme late_evening
" colorscheme lazarus
" colorscheme legiblelight
" colorscheme leglight2
" colorscheme leo
" colorscheme less
" colorscheme lettuce
" colorscheme leya
" colorscheme lightcolors
" colorscheme lightning
" colorscheme lilac
" colorscheme lilydjwg_dark
" colorscheme lilydjwg_green
" colorscheme lilypink
" colorscheme lingodirector
" colorscheme liquidcarbon
" colorscheme literal_tango
" colorscheme lizard
" colorscheme lizard256
" colorscheme lodestone
" colorscheme loogica
" colorscheme louver
" colorscheme lucid
" colorscheme lucius
" colorscheme luinnar
" colorscheme lumberjack
" colorscheme luna-term
" colorscheme luna
" colorscheme lxvc
" colorscheme mac_classic
" colorscheme made_of_code
" colorscheme madeofcode
" colorscheme magicwb
" colorscheme mango
" colorscheme manuscript
" colorscheme manxome
" colorscheme marklar
" colorscheme maroloccio
" colorscheme maroloccio2
" colorscheme maroloccio3
" colorscheme mars
" colorscheme martin_krischik
" colorscheme material-theme
" colorscheme material
" colorscheme materialbox
" colorscheme materialtheme
" colorscheme matrix
" colorscheme maui
" colorscheme mayansmoke
" colorscheme mdark
" colorscheme mellow
" colorscheme meta5
" colorscheme metacosm
" colorscheme midnight
" colorscheme miko
" colorscheme minimalist
" colorscheme mint
" colorscheme mizore
" colorscheme mod8
" colorscheme mod_tcsoft
" colorscheme mojave
" colorscheme molokai
" colorscheme molokai_dark
" colorscheme monoacc
" colorscheme monochrome
" colorscheme monokai-chris
" colorscheme monokain
" colorscheme montz
" colorscheme moonshine
" colorscheme moonshine_lowcontrast
" colorscheme mophiaDark
" colorscheme mophiaSmoke
" colorscheme mopkai
" colorscheme moria
" colorscheme morning
" colorscheme moss
" colorscheme motus
" colorscheme mrkn256
" colorscheme mrpink
" colorscheme mud
" colorscheme muon
" colorscheme murphy
" colorscheme mushroom
" colorscheme mustang
" colorscheme native
" colorscheme nature
" colorscheme navajo-night
" colorscheme navajo
" colorscheme nazca
" colorscheme nedit
" colorscheme nedit2
" colorscheme nefertiti
" colorscheme neon
" colorscheme neonwave
" colorscheme nerv-ous
" colorscheme neutron
" colorscheme neverland-darker
" colorscheme neverland
" colorscheme neverland2-darker
" colorscheme neverland2
" colorscheme neverness
" colorscheme nevfn
" colorscheme newspaper
" colorscheme newsprint
" colorscheme nicotine
" colorscheme night
" colorscheme nightVision
" colorscheme night_vision
" colorscheme nightflight
" colorscheme nightflight2
" colorscheme nightshade
" colorscheme nightshade_print
" colorscheme nightshimmer
" colorscheme nightsky
" colorscheme nightwish
" colorscheme no_quarter
" colorscheme northland
" colorscheme northsky
" colorscheme norwaytoday
" colorscheme nour
" colorscheme nuvola
" colorscheme obsidian
" colorscheme obsidian2
" colorscheme oceanblack
" colorscheme oceanblack256
" colorscheme oceandeep
" colorscheme oceanlight
" colorscheme olive
" colorscheme onedark
" colorscheme orange
" colorscheme osx_like
" colorscheme otaku
" colorscheme oxeded
" colorscheme pablo
" colorscheme pacific
" colorscheme paintbox
" colorscheme parsec
" colorscheme peachpuff
" colorscheme peaksea
" colorscheme pencil
" colorscheme penultimate
" colorscheme peppers
" colorscheme perfect
" colorscheme pf_earth
" colorscheme phd
" colorscheme phoenix
" colorscheme phphaxor
" colorscheme phpx
" colorscheme pink
" colorscheme playroom
" colorscheme pleasant
" colorscheme potts
" colorscheme predawn
" colorscheme preto
" colorscheme pride
" colorscheme primary
" colorscheme print_bw
" colorscheme prmths
" colorscheme professional
" colorscheme proton
" colorscheme ps_color
" colorscheme pspad
" colorscheme pt_black
" colorscheme putty
" colorscheme pw
" colorscheme pyte
" colorscheme python
" colorscheme quagmire
" colorscheme radicalgoodspeed
" colorscheme railscasts
" colorscheme rainbow_autumn
" colorscheme rainbow_fine_blue
" colorscheme rainbow_night
" colorscheme rainbow_sea
" colorscheme rakr-light
" colorscheme random
" colorscheme rastafari
" colorscheme rcg_gui
" colorscheme rcg_term
" colorscheme rdark-terminal
" colorscheme rdark
" colorscheme redblack
" colorscheme redstring
" colorscheme refactor
" colorscheme relaxedgreen
" colorscheme reliable
" colorscheme reloaded
" colorscheme revolutions
" colorscheme robinhood
" colorscheme ron
" colorscheme rootwater
" colorscheme sadek1
" colorscheme sand
" colorscheme sandydune
" colorscheme satori
" colorscheme saturn
" colorscheme scheakur
" colorscheme scite
" colorscheme scooby
" colorscheme sean
" colorscheme seashell
" colorscheme seattle
" colorscheme selenitic
" colorscheme seoul
" colorscheme seoul256-light
" colorscheme seoul256
" colorscheme seti
" colorscheme settlemyer
" colorscheme sexy-railscasts
" colorscheme sf
" colorscheme shades-of-teal
" colorscheme shadesofamber
" colorscheme shine
" colorscheme shobogenzo
" colorscheme sienna
" colorscheme sierra
" colorscheme sift
" colorscheme silent
" colorscheme simple256
" colorscheme simple_b
" colorscheme simpleandfriendly
" colorscheme simplewhite
" colorscheme simplon
" colorscheme skittles_berry
" colorscheme skittles_dark
" colorscheme sky
" colorscheme slate2
" colorscheme smp
" colorscheme smpl
" colorscheme smyck
" colorscheme soda
" colorscheme softblue
" colorscheme softbluev2
" colorscheme softlight
" colorscheme sol-term
" colorscheme sol
" colorscheme solarized
" colorscheme sole
" colorscheme sonofobsidian
" colorscheme sonoma
" colorscheme sorcerer
" colorscheme soruby
" colorscheme soso
" colorscheme sourcerer
" colorscheme southernlights
" colorscheme southwest-fog
" colorscheme spacegray
" colorscheme spectro
" colorscheme spiderhawk
" colorscheme spring
" colorscheme sprinkles
" colorscheme stackoverflow
" colorscheme stingray
" colorscheme stonewashed-256
" colorscheme stonewashed-gui
" colorscheme strange
" colorscheme strawimodo
" colorscheme summerfruit
" colorscheme summerfruit256
" colorscheme sunburst
" colorscheme surveyor
" colorscheme swamplight
" colorscheme sweater
" colorscheme symfony
" colorscheme synic
" colorscheme tabula
" colorscheme tango-desert
" colorscheme tango-morning
" colorscheme tango
" colorscheme tango2
" colorscheme tangoX
" colorscheme tangoshady
" colorscheme taqua
" colorscheme tayra
" colorscheme tchaba
" colorscheme tchaba2
" colorscheme tcsoft
" colorscheme telstar
" colorscheme termschool
" colorscheme tesla
" colorscheme tetragrammaton
" colorscheme textmate16
" colorscheme thegoodluck
" colorscheme thestars
" colorscheme thor
" colorscheme thornbird
" colorscheme tibet
" colorscheme tidy
" colorscheme tir_black
" colorscheme tolerable
" colorscheme tomatosoup
" colorscheme tony_light
" colorscheme toothpik
" colorscheme torte
" colorscheme transparent
" colorscheme triplejelly
" colorscheme trivial256
" colorscheme trogdor
" colorscheme tropikos
" colorscheme turbo
" colorscheme tutticolori
" colorscheme twilight
" colorscheme twilight256
" colorscheme twitchy
" colorscheme two2tango
" colorscheme ubaryd
" colorscheme ubloh
" colorscheme umber-green
" colorscheme understated
" colorscheme underwater-mod
" colorscheme underwater
" colorscheme up
" colorscheme valloric
" colorscheme vanzan_color
" colorscheme vc
" colorscheme vcbc
" colorscheme vexorian
" colorscheme vibrantink
" colorscheme vilight
" colorscheme vimbrant
" colorscheme visualstudio
" colorscheme vividchalk
" colorscheme vj
" colorscheme void
" colorscheme vydark
" colorscheme vylight
" colorscheme wargrey
" colorscheme warm_grey
" colorscheme wasabi256
" colorscheme watermark
" colorscheme wellsokai
" colorscheme white
" colorscheme whitebox
" colorscheme whitedust
" colorscheme widower
" colorscheme win9xblueback
" colorscheme winter
" colorscheme wintersday
" colorscheme woju
" colorscheme wolfpack
" colorscheme wombat
" colorscheme wombat256
" colorscheme wombat256i
" colorscheme wombat256mod
" colorscheme wood
" colorscheme wuye
" colorscheme xemacs
" colorscheme xian
" colorscheme xmaslights
" colorscheme xoria256
" colorscheme xterm16
" colorscheme yeller
" colorscheme zazen
" colorscheme zellner
" colorscheme zen
" colorscheme zenburn  " Nice
" colorscheme zenesque
" colorscheme zephyr
" colorscheme zmrok
" colorscheme znake



call plug#end()
filetype plugin indent on     " Enable filetype recognition
