" Buffers
  nmap <LEADER>b :Buffers<CR>
  nmap <LEADER>bb :Buffers!<CR>

" DEOPLETE
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Signify
  nmap <leader>sd :SignifyDiff<CR>

" Fuzzy Finder (review)
  nnoremap <leader>ff :FZFFiles<cr>
  nnoremap <leader>fb :FZFBuffers<cr>

" Edit and reload vimrc
  nnoremap <leader>ve :edit $MYVIMRC<CR>
  nnoremap <leader>vr :source $MYVIMRC<CR>

" Errors list
  nnoremap <leader>lo :lopen<CR>
  nnoremap <leader>lc :lclose<CR>

" Tabs management
  nnoremap <leader><TAB> gt
  nnoremap <leader><S-TAB> gT

" Exit vim
  nnoremap <silent><leader>qq :qall<CR>

" Rename File
  map <leader>n :call RenameFile()<cr>

" open in terminal mode
  nnoremap <leader>zz :terminal<CR>
  nnoremap <leader>zh :new<CR>:terminal<CR>
  nnoremap <leader>zv :vnew<CR>:terminal<CR>
  tnoremap <Esc> <C-\><C-n>```
  noremap <Leader>sc :Ag<CR>
  noremap <Leader>lc :lclose<cr>
  noremap <Leader>lo :lopen<cr>
  noremap <Up> <Nop>
  noremap <Down> <Nop>
  noremap <Left> <Nop>
  noremap <Right> <Nop>

" nerdtree
  nmap <F2> :NERDTreeToggle<CR>
  " nmap <F3> :TagbarToggle<CR>

" test-vim
  nnoremap <leader>tf :TestFile<CR>
  nnoremap <leader>tl :TestNearest<CR>
  nnoremap <leader>tr :TestLast<CR>
  nnoremap <leader>to :Copen<CR>
  nnoremap <leader>tv :TestVisit<CR>

" Show undo list
" nnoremap <leader>u :GundoToggle<CR>

" Tabs
noremap <silent> nt :tabnew<CR>
map <silent> <C-w> :q<CR>
noremap <M-Left> gT
noremap <M-Right> gt
" Remap arrow keys to change between buffers
noremap <C-S-Up> <C-w>k
noremap <C-S-Down> <C-w>j
noremap <C-S-Left> <C-w>h
noremap <C-S-Right> <C-w>l

" quick list and location list
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>
