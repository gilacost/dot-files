
"
" Install iTerm >= 3.1
" Install NVim
" Install FiraCode
" Install FZF 
" Remember run HealthChecks
"

"
" Vim-Plug Section
"

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'              " Git Gutter and Hunks
Plug 'jszakmeister/vim-togglecursor'       " Cursor Shape Mode Based
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                    " Fuzzy Search
Plug 'mbbill/undotree'                     " Undo Historial
Plug 'mhinz/vim-startify'                  " Fancy Start Screen
"Plug 'rakr/vim-one'                       " Theme
Plug 'mhartington/oceanic-next'            " Theme
"Plug 'joshdick/onedark.vim'               " Theme
Plug 'scrooloose/nerdcommenter'            " Easy Comments
Plug 'tpope/vim-fugitive'                  " Git Integration
Plug 'tpope/vim-rhubarb'                   " Gbrowse + Github
Plug 'tpope/vim-surround'                  " Parenthesizing made simple
Plug 'tpope/vim-vinegar'                   " Enhanced netrw (Like NerdTree)
"Plug 'fweep/vim-tabber'                   " Tab Utilities
Plug 'vim-airline/vim-airline'             " Status and Tab Line
Plug 'vim-airline/vim-airline-themes'      " Status Line Theme
Plug 'w0rp/ale'                            " Syntax Check
Plug 'ryanoasis/vim-devicons'              " Icons
Plug 'easymotion/vim-easymotion'           " Easy Motion
"Plug 't9md/vim-choosewin'                 " choosewin
Plug 'mattn/emmet-vim'                     " Emmet
Plug 'rizzatti/dash.vim'                   " Dash app (Doc search)

Plug 'roxma/nvim-completion-manager' " Auto Complete
Plug 'calebeby/ncm-css'
Plug 'roxma/ncm-elm-oracle'
Plug 'roxma/ncm-flow'

Plug 'jceb/vim-orgmode'      " The Org Mode
Plug 'vim-scripts/utl.vim'   " Open links
Plug 'tpope/vim-repeat'      " Repeat plugin commands
Plug 'tpope/vim-speeddating' " Use ^+A/^+X with dates
Plug 'mattn/calendar-vim'    " A Calendar in Vim

Plug 'vim-erlang/vim-erlang-runtime'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-erlang/vim-erlang-tags'


"Plug 'autozimu/LanguageClient-neovim', {
    "\ 'branch': 'next',
    "\ 'do': 'bash install.sh',
    "\ }
"Plug 'reasonml-editor/vim-reason-plus'

"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  
"Plug 'wokalski/autocomplete-flow'                              Auto Complete: Javascript
"Plug 'pbogut/deoplete-elm'                                     Auto Complete: Elm

Plug 'ElmCast/elm-vim'                     " Language Support: Elm
Plug 'Quramy/tsuquyomi'                    " Language Support: TypeScript
Plug 'leafgarland/typescript-vim'          " Syntax: TypeScript
Plug 'elixir-lang/vim-elixir'              " Language Support: Elixir
"Plug 'slashmili/alchemist.vim'             " Language Support: Elixir
Plug 'raichoo/purescript-vim'              " Language Support: PureScript
Plug 'frigoeu/psc-ide-vim'                 " Language Support: PureScript
Plug 'fatih/vim-go'                        " Language Support: Golang
Plug 'pangloss/vim-javascript'             " Language Support: JavaScript
Plug 'dleonard0/pony-vim-syntax'           " Language Support: Pony
Plug 'neovimhaskell/haskell-vim'           " Language Support: Haskell (Better Syntax)
Plug 'alx741/vim-hindent'                  " Language Support: Haskell (Auto Indent)
Plug 'parsonsmatt/intero-neovim'           " Language Support: Haskell (Repol Env)
" Plug 'reasonml/vim-reason'                 " Language Support: ReasonML
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
call plug#end()


"
" Common Configuration
"

" UI Config

set encoding=utf8                               " UTF-8 Encoding
set hidden                                      " don't unload buffer when switching away
set modeline                                    " allow per-file settings via modeline
set secure                                      " disable unsafe commands in local .vimrc files
set noswapfile                                  " disable swap files
set hlsearch incsearch ignorecase smartcase     " search
set wildmenu                                    " completion
set backspace=indent,eol,start                  " sane backspace
set clipboard+=unnamed,unnamedplus              " use the system clipboard for yank/put/delete
set mouse=a                                     " enable mouse for all modes settings
set mousemodel=popup                            " right-click pops up context menu
set number                                      " show absolute line number of the current line
set scrolloff=10                                " scroll the window so we can always see 10 lines around the cursor
set sidescrolloff=5                             " horizontal scrolloff
set textwidth=80                                " wrap at 80 characters like a valid human
set nowrap                                      " do not break lines when they are too long
set showcmd                                     " show command in bottom bar
set cursorline                                  " highlight current line
filetype indent on                              " load filetype-specific indent files
set wildmenu                                    " visual autocomplete for command menu
set lazyredraw                                  " redraw only when we need to.
set showmatch                                   " highlight matching [{()}]
set spell                                       " spell checking
set splitbelow                                  " vertical split below
set splitright                                  " horizontal split right
set list                                        " show invisibles
set guioptions-=e                               " enable gui options
set nofoldenable                                " disable folding
set tabstop=2 shiftwidth=2 expandtab            " use spaces, indent size = 2
set lcs=tab:▸\ ,trail:·,nbsp:%
let &colorcolumn="80,120" " show length column
"hi ColorColumn guibg=#252930 ctermbg=236 gui=NONE cterm=NONE

"
" Color Scheme & Theme
"

" Oceanic Next
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

" Enable true color support (only works with neovim + iterm)
" let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
" set termguicolors


"let g:onedark_termcolors = 16
"let g:onedark_terminal_italics = 1
"set background=dark
"set background=light
"syntax on
"colorscheme onedark


" Oceanic Theme - https://github.com/mhartington/oceanic-next
" syntax on
" colorscheme OceanicNext
" set background = dark


" AirLine
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
"let g:airline_theme='one'
let g:airline_theme='oceanicnext'
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'


" Enable Temporal Editing (like when using git commit) inside a terminal buffer.
" Thanks to https://github.com/mhinz/neovim-remote
if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait'
endif

" Leader
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
let maplocalleader = "\\"
inoremap jj <Esc>

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Buffer Navigation
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>

" Terminal emulation
augroup terminal
autocmd TermOpen * setlocal nospell
autocmd TermOpen * setlocal nonumber
augroup END
nnoremap <leader>zz :terminal<CR>
nnoremap <leader>zh :new<CR>:terminal<CR>
nnoremap <leader>zv :vnew<CR>:terminal<CR>
tnoremap <Esc> <C-\><C-n>

" Use `ALT+{h,j,k,l}` to navigate windows from any mode
":tnoremap <A-h> <C-\><C-N><C-w>h
":tnoremap <A-j> <C-\><C-N><C-w>j
":tnoremap <A-k> <C-\><C-N><C-w>k
":tnoremap <A-l> <C-\><C-N><C-w>l
":inoremap <A-h> <C-\><C-N><C-w>h
":inoremap <A-j> <C-\><C-N><C-w>j
":inoremap <A-k> <C-\><C-N><C-w>k
":inoremap <A-l> <C-\><C-N><C-w>l
":nnoremap <A-h> <C-w>h
":nnoremap <A-j> <C-w>j
":nnoremap <A-k> <C-w>k
":nnoremap <A-l> <C-w>l

"
" Deoplete
"
"let g:deoplete#enable_at_startup = 1 " enable deoplete
"let g:deoplete#enable_smart_case = 1
"let g:deoplete#omni#functions = {}
"let g:deoplete#sources = {}
"let g:deoplete#sources._ = ['file', 'buffer']
"let g:deoplete#omni#input_patterns = {}
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

"
" Startify
"
let g:startify_custom_header = []

"
" GitGutter
"
let g:gitgutter_eager = 1    " runs diffs on buffer switch
let g:gitgutter_enabled = 1  " enables gitgutter (hunks only)
let g:gitgutter_realtime = 1 " runs diffs when stop writting
let g:gitgutter_signs = 1    " shows signs on the gutter
let g:gitgutter_sign_added = '·'
let g:gitgutter_sign_modified = '·'
let g:gitgutter_sign_removed = '·'
let g:gitgutter_sign_removed_first_line = '·'
let g:gitgutter_sign_modified_removed = '·'
noremap <Leader>hn :GitGutterNextHunk<CR>
noremap <Leader>hp :GitGutterPrevHunk<CR>
noremap <Leader>hs :GitGutterStageHunk<CR>
noremap <Leader>hu :GitGutterUndoHunk<CR>


"
" FZF
"
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
noremap <Leader>sc :Ag<CR>
noremap <Leader>sf :FZF<CR>
noremap <Leader>sg :GitFiles<CR>

"
" Fugitive
"
noremap <Leader>gs :Gstatus<cr>

"
" Netrw
"
let s:treedepthstring= "|> "

"
" Syntastic
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 1

"let g:syntastic_c_include_dirs = ['node_modules/nan']
"let g:syntastic_c_remove_include_errors = 1

"let g:syntastic_cpp_include_dirs = ['node_modules/nan']
"let g:syntastic_cpp_remove_include_errors = 1

""let g:syntastic_javascript_checkers = ['jshint']
"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_javascript_eslint_exec = '/Users/alvivi/Projects/sandhill/node_modules/.bin/eslint'

"let g:syntastic_html_tidy_ignore_errors = ['<input> proprietary attribute "required"']


"
" Ale
"
let g:airline#extensions#ale#enabled = 1
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_linters = {
\   'javascript': ['prettier', 'flow'],
\   'haskell': ['stack-ghc-mod', 'hlint'],
\   'typescript': ['tslint', 'tsserver'],
\}
let g:ale_fixers = {
\   'elixir': [ 'mix_format', 'remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\}
noremap <Leader>gd :ALEGoToDefinition<CR>
noremap <Leader>gdt :ALEGoToDefinitionInTab<CR>

"
" Haskell
"

" haskell-vim

" Align 'then' two spaces after 'if'
let g:haskell_indent_if = 2 
" Indent 'where' block two spaces under previous body
let g:haskell_indent_before_where = 2 
" Prefer starting Intero manually (faster startup times)

" haskell-vim

let g:hindent_on_save = 1

" haskell-vim

" Use ALE (works even when not using Intero)
let g:intero_use_neomake = 0

"
" Elm
"
let g:elm_format_autosave = 1
let g:elm_setup_keybindings = 0
"let g:deoplete#omni#functions.elm = ['elm#Complete']
"let g:deoplete#omni#input_patterns.elm = '[^ \t]+'
"let g:deoplete#sources.elm = ['omni'] + g:deoplete#sources._


"
" Easy Motion
"
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
nmap s <Plug>(easymotion-s2)

let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_smartcase = 1

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

:nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

"map  n <Plug>(easymotion-next)
"map  N <Plug>(easymotion-prev)


