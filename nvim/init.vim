set encoding=utf-8 " default character encoding

" Set leader keys before anything else
let mapleader      = "\<SPACE>"
let maplocalleader = ","

" This need to be set before any plugin loads
let g:ale_emit_conflict_warnings = 0

" filetype off
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')
" grep please
" Plug 'mhinz/vim-grepper'
" startify (recent files)
Plug 'mhinz/vim-startify'
"SQL completion
Plug 'vim-scripts/SQLComplete.vim'
" " Folder navigation
Plug 'scrooloose/nerdtree'
" Code formating and go to definition
Plug 'w0rp/ale'
" elmo
Plug 'elmcast/elm-vim'
" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'
" Fuzzy finder
" Plugin outside ~/.vim/plugged with post-update hook TO BE REMOVED
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Fuzzy Search
" Pope's mailic
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-speeddating'
" Git 
Plug 'tpope/vim-fugitive'
" Show diff with style
Plug 'mhinz/vim-signify'
" elixir and phoenix stuff
Plug 'c-brenn/phoenix.vim'
Plug 'slashmili/alchemist.vim'
" vim dispatch allows to run external commands asynchronously
Plug 'tpope/vim-dispatch'
" neovim dispatch adapter 
Plug 'radenling/vim-dispatch-neovim'
" gruvox theme and theme selection 
Plug 'morhetz/gruvbox'
" fancy status bar 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Org mode
Plug  'jceb/vim-orgmode'
"Dark powered asynchronous completion framework for neovim/Vim8
" Use tab for completion if visible if not normal tab
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Initialize plugin system
call plug#end()

" filetype plugin indent on
syntax enable

source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/general.vim
source $HOME/.config/nvim/keys.vim
source $HOME/.config/nvim/statusline.vim
" source $HOME/.config/nvim/projections.vim

" Change diff signs
" This has to be after the general.vim loading since loading the colorscheme
" overwrites this... however I can't add it to the plugins.vim file and load
" that after the general.vim because the neomake autocommands for the colors
" need to be defined before loading the colorscheme :D cool, eh?

highlight DiffAdd           cterm=bold ctermbg=none ctermfg=2
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=1
highlight DiffChange        cterm=bold ctermbg=none ctermfg=4

highlight SignifySignAdd    cterm=bold ctermbg=none ctermfg=2
highlight SignifySignDelete cterm=bold ctermbg=none ctermfg=1
highlight SignifySignChange cterm=bold ctermbg=none ctermfg=4
