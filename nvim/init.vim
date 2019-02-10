set encoding=utf-8 " default character encoding

" Set leader keys before anything else
let mapleader      = "\<SPACE>"
let maplocalleader = ","

filetype off
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')
" gruvox theme and theme selection
 Plug 'morhetz/gruvbox'
" SQL completion
Plug 'vim-scripts/SQLComplete.vim'
" Folder navigation
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
" elixir and phoenix stuff
" Plug 'c-brenn/phoenix.vim'
Plug 'slashmili/alchemist.vim'
" vim dispatch allows to run external commands asynchronously
Plug 'tpope/vim-dispatch'
" only for hackers
" Plug 'easymotion/vim-easymotion'
" neovim dispatch adapter
Plug 'radenling/vim-dispatch-neovim'
" fancy status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Org mode
Plug  'jceb/vim-orgmode'
"Dark powered asynchronous completion framework for neovim/Vim8
" Use tab for completion if visible if not normal tab
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" startify (recent files)
Plug 'mhinz/vim-startify'
" Git
" Show diff with style
Plug 'mhinz/vim-signify'
" Terraform
Plug 'hashivim/vim-terraform'
Plug 'vim-syntastic/syntastic'
Plug 'juliosueiras/vim-terraform-completion'
" Vim test
Plug 'janko-m/vim-test'
" Initialize plugin system
call plug#end()

source $HOME/.config/nvim/general.vim
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/keys.vim
source $HOME/.config/nvim/statusline.vim
source $HOME/.config/nvim/projections.vim

if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif
