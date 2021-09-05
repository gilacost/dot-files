
" Set leader keys before anything else
" SHOULD I MOVE THIS TO BASE (SETS)
let mapleader      = "\<SPACE>"
let maplocalleader = ','


let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if has('termguicolors')
  set termguicolors
endif


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

"""""""""""""""""""""""" LSPSAGA/LSP """""""""""""""""""""""""""""""""""
" TODO MOVE THIS TO LUA and align with lspconfig commands
  nnoremap <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
  nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
  " -- jump diagnostic
  nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
  nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
  nnoremap <silent> ff <cmd>lua vim.lsp.buf.formatting()<CR>
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
" nnoremap <leader>u :GundoToggle<CR>

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

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" replace all
:nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" Tab and Shift-Tab in normal mode to navigate buffers
map <Tab> :bnext<CR>
map <S-Tab> :bprevious<CR>

" Current directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>


"""""""""""""""""""""" SATUSLINE """"""""""""""""""""""""""""""""
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'
let g:airline_section_x = '%{FugitiveStatusline()}'

"Refresh devicons
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync()
"""""""""""""""""""" ALE """"""""""""""""""""""""""""""""""""""""
" let g:ale_disable_lsp = 1
" let g:ale_linters_explicit = 1
" let g:ale_fix_on_save = 1

" let g:ale_linters = {
"    \   'dockerfile': ['hadolint']
"    \}

" let g:ale_fixers = {
"    \}
