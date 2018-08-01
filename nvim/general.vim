    let base16colorspace=256
    let $FZF_DEFAULT_COMMAND = 'ag -g ""'
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
    colorscheme gruvbox
    set background=dark
" More natural splits
    set splitbelow          " Horizontal split below current.
    set splitright          " Vertical split to right of current.
" Show non visual chars
    set listchars=trail:~,tab:▸\ ,eol:¬ " show special characters
    set list
    set noswapfile " Disable Swap Files
" Add spell check to git commits
    autocmd FileType gitcommit setlocal spell spelllang=en_us
" Set JSON on mustached json files
    autocmd BufRead,BufNewFile *.json.mustache set filetype=json.mustache
" Nerd tree quit on enter I guess
    autocmd VimEnter * if (0 == argc()) | NERDTree | endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    augroup terminal " Terminal emulation
    autocmd TermOpen * setlocal nospell
    autocmd TermOpen * setlocal nonumber
    augroup END
