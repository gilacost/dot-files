    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    let $FZF_DEFAULT_COMMAND = 'ag -g ""'
    set mouse=""
" show invisibles
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
    set colorcolumn=80,100
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
" More natural splits
    set splitbelow          " Horizontal split below current.
    set splitright          " Vertical split to right of current.
" Show non visual chars
" non-printable character display settings when :set list
    set noswapfile " Disable Swap Files
" Terrapou
    set nocompatible
    syntax on
    filetype plugin indent on
    set spell spelllang=en_us
" " Status line syntastic
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
" (Optional)Remove Info(Preview) window
    set completeopt-=preview
" (Optional)Hide Info(Preview) window after completions
    autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" Set JSON on mustached json files
    autocmd BufRead,BufNewFile *.json.mustache set filetype=json.mustache

    augroup terminal " Terminal emulation
    autocmd TermOpen * setlocal nospell
    autocmd TermOpen * setlocal nonumber
    augroup END
" Rename current file
    function! RenameFile()
        let old_name = expand('%')
        let new_name = input('New file name: ', expand('%'), 'file')
        if new_name != '' && new_name != old_name
            exec ':saveas ' . new_name
            exec ':silent !rm ' . old_name
            redraw!
        endif
    endfunction
    set termguicolors
    set background=dark
    colorscheme gruvbox
" FZF functions
" This command now supports CTRL-T, CTRL-V, and CTRL-X key bindings
" and opens fzf according to g:fzf_layout setting.
command! Buffers call fzf#run(fzf#wrap(
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')}))
" This extends the above example to open fzf in fullscreen
" when the command is run with ! suffix (Buffers!)
command! -bang Buffers call fzf#run(fzf#wrap(
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')}, <bang>0))

highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()
