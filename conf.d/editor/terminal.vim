" terminal
if has('nvim')
    autocmd TermOpen term://* startinsert
endif

augroup terminal
autocmd TermOpen * setlocal nospell
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal scrollback=1000
autocmd TermOpen * setlocal signcolumn=no
augroup END
nnoremap <leader>zz :terminal<CR>
nnoremap <leader>zh :new<CR>:terminal<CR>
nnoremap <leader>zv :vnew<CR>:terminal<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>
highlight! link TermCursor Cursor
highlight! TermCursorNC guibg=teal guifg=white ctermbg=1 ctermfg=15

  " https://github.com/neovim/neovim/issues/11072
au TermEnter * setlocal scrolloff=0
au TermLeave * setlocal scrolloff=10
" terminal
