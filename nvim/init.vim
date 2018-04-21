set encoding=utf-8 " default character encoding

" Set leader keys before anything else
let mapleader      = " "
let maplocalleader = ","

filetype off
set encoding=utf-8
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')
" Code formating and go to definition
Plug 'w0rp/ale'
"Dark powered asynchronous completion framework for neovim/Vim8
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Use tab for completion if visible if not normal tab
" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'
" Fuzzy finder
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Fuzzy finding everywhere
Plug 'junegunn/fzf.vim'
" Please let me commnet that
Plug 'tpope/vim-commentary'
" usefull pairing of handy bracket mappings
Plug 'tpope/vim-unimpaired'
" sourrounds selection if surrounded
Plug 'tpope/vim-surround'
" asyncronous linting for many languages
" Projectionist for semantic search
" Plug 'tpope/vim-projectionist'
" vim dispatch allows to run external commands asynchronously
" Plug 'tpope/vim-dispatch'
" neovim dispatch adapter 
" Plug 'tpope/vim-dispatch-neovim'
" gruvox theme and theme selection 
Plug 'morhetz/gruvbox'
" fancy status bar 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Initialize plugin system
call plug#end()

" filetype plugin indent on
" syntax enable

" source $HOME/.config/nvim/plugins.vim
" source $HOME/.config/nvim/general.vim
" source $HOME/.config/nvim/keys.vim
" source $HOME/.config/nvim/statusline.vim
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
