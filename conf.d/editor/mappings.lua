--- Set leader keys before anything else
--- SHOULD I MOVE THIS TO BASE (SETS)
let mapleader      = " "
let maplocalleader = ','

--- PLUGINS ---

" test
let test#strategy = 'neovim'
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" test

--- MAPPINGS ---

--- Support nested vim
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

--- quick list and location list
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

--- Rename File
map <leader>n :call RenameFile()<cr>

--- Show undo list
nnoremap <leader>u :GundoToggle<CR>

--- Tabs
noremap <silent> nt :tabnew<CR>:terminal<CR>
noremap <M-Left> gT
noremap <M-Right> gt

--- splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

--- resizing
nnoremap <C-n> <C-w>\|<C-w>_
nnoremap <C-b> <C-w>=

--- Easy Motion
map <Leader>f <Plug>(easymotion-bd-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
nmap s <Plug>(easymotion-s2)

let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_smartcase = 1
let g:vim_markdown_folding_disabled = 1

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

--- replace all
:nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

--- Tab and Shift-Tab in normal mode to navigate buffers
map <Tab> :bnext<CR>
map <S-Tab> :bprevious<CR>

--- Git
nnoremap <leader>nh :GitGutterNextHunk<CR>
nnoremap <leader>ph :GitGutterPrevHunk<CR>
nnoremap <leader>sh :GitGutterStageHunk<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>

--- LSP TROUBLE ---
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
--- LSP TROUBLE ---
