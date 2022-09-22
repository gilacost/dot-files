
" Set leader keys before anything else
" SHOULD I MOVE THIS TO BASE (SETS)
let mapleader      = "\<SPACE>"
let maplocalleader = ','

autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" startyify
  let g:startify_change_to_vcs_root = 1 "review
" SHOULD I MOVE THIS TO BASE (SETS)
" autocmd BufWritePre * lua vim.lsp.buf.formatting()

" highlight white spaces in RED
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

"""""""""""""""""""""" PLUGINS """"""""""""""""""""""""""""""""

" test
let test#strategy = 'neovim'
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" test

"""""""""""""""""""""""" LSPSAGA """""""""""""""""""""""""""""""""""

" random functions
function! Repeat()
  let times = input("Count: ")
  let char  = input("Char: ")
  exe ":normal a" . repeat(char, times)
endfunction

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

"""""""""""""""""""""" MAPPINGS """"""""""""""""""""""""""""""""

" Support nested vim
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

" quick list and location list
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

" Rename File
map <leader>n :call RenameFile()<cr>

" Show undo list
nnoremap <leader>u :GundoToggle<CR>

" Tabs
noremap <silent> nt :tabnew<CR>:terminal<CR>
noremap <M-Left> gT
noremap <M-Right> gt

" splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" resizing
nnoremap <C-n> <C-w>\|<C-w>_
nnoremap <C-b> <C-w>=

" Easy Motion
map <Leader>f <Plug>(easymotion-bd-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
nmap s <Plug>(easymotion-s2)

let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_smartcase = 1
let g:vim_markdown_folding_disabled = 1

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" replace all
:nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" Tab and Shift-Tab in normal mode to navigate buffers
map <Tab> :bnext<CR>
map <S-Tab> :bprevious<CR>

" Git
nnoremap <leader>nh :GitGutterNextHunk<CR>
nnoremap <leader>ph :GitGutterPrevHunk<CR>
nnoremap <leader>sh :GitGutterStageHunk<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>

"""""""""""""""""""""" SATUSLINE """"""""""""""""""""""""""""""""
let g:airline_theme='onedark'
" let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'
let g:airline_section_x = '%{FugitiveStatusline()}'

"Refresh devicons
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

"""""""""""""""""""""format on save""""""""""""""""""""""""""""""
autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync()
au BufNewFile,BufRead rebar.config  setf erlang
au BufNewFile,BufRead *app.src  setf erlang
" au BufNewFile,BufRead *heex  setf elixir
"""""""""""""""""""""format on save""""""""""""""""""""""""""""""

"""""""""""""""""""""LSP TROUBLE"""""""""""""""""""""""""""""""""
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
"""""""""""""""""""""LSP TROUBLE"""""""""""""""""""""""""""""""""

let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

function! ToggleGenericFormat()
  let g:neoformat_basic_format_retab = !g:neoformat_basic_format_retab
  let g:neoformat_basic_format_trim = !g:neoformat_basic_format_retab
endfunction

let g:neoformat_prettier = {
  \ 'exe': '/etc/profiles/per-user/pepo/bin/prettier',
  \ 'args': ['--stdin-filepath', '"%:p"'],
  \ 'stdin': 1,
  \ }

let g:neoformat_enabled_elixir = []
let g:neoformat_javascript_prettier = g:neoformat_prettier
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_json_prettier = g:neoformat_prettier
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_css_prettier = g:neoformat_prettier
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_typescript_prettier = g:neoformat_prettier
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_yaml_prettier = g:neoformat_prettier
let g:neoformat_enabled_yaml = ['prettier']

augroup fmt
  autocmd!
  au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
augroup END
