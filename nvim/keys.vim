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

" Move between windows
" nnoremap <silent><leader>wj :wincmd j<CR>
" nnoremap <silent><leader>wk :wincmd k<CR>
" nnoremap <silent><leader>wl :wincmd l<CR>
" nnoremap <silent><leader>wh :wincmd h<CR>

" Move windows around
" nnoremap <silent><leader>wJ :wincmd J<CR>
" nnoremap <silent><leader>wK :wincmd K<CR>
" nnoremap <silent><leader>wL :wincmd L<CR>
" nnoremap <silent><leader>wH :wincmd H<CR>

" Split screens
" nnoremap <silent><leader>wv :wincmd v<CR>
" nnoremap <silent><leader>ws :wincmd s<CR>

" " quick list and location list
" nnoremap <leader>qo :copen<CR>
" nnoremap <leader>qc :cclose<CR>

" grepper
  " nnoremap \\ :Grepper -noprompt -cword<CR>
  " nnoremap <leader>s :Grepper -query<SPACE>
