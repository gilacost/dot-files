set mouse=""
" use the system clipboard for yank/put/delete
set clipboard+=unnamed,unnamedplus
set number
" Indent
set shiftwidth=2   " number of spaces to use for each step of (auto)indent.
set shiftround     " round indent to multiple of 'shiftwidth'
set smarttab
set autoindent
set copyindent
set smartindent
set colorcolumn=100
set tabstop=2 " - Two spaces wide
set softtabstop=2
set expandtab " - Expand them all
set shiftwidth=2 " - Indent by 2 spaces by default
set hlsearch " Highlight search results
set incsearch " Incremental search, search as you type
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase
set cursorline " highlight cursor position
set cursorcolumn
set title "set the title of the iterm tab
set background=dark
" syntax enable
colorscheme gruvbox
let base16colorspace=256
" Show non visual chars
set listchars=trail:~,tab:▸\ ,eol:¬ " show special characters
set list
" Add spell check to git commits
autocmd FileType gitcommit setlocal spell spelllang=en_us
" Set JSON on mustached json files
autocmd BufRead,BufNewFile *.json.mustache set filetype=json.mustache

" Configure backupfiles
set backup
set backupdir   =$HOME/.config/nvim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.config/nvim/files/swap/
set updatecount =100
set undofile
set undodir     =$HOME/.config/nvim/files/undo/
set viminfo     ='100,n$HOME/.config/nvim/files/info/viminfo
