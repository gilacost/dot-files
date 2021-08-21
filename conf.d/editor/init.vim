set encoding=utf-8 " default character encoding

" Set leader keys before anything else
"
let mapleader      = "\<SPACE>"
let maplocalleader = ','

"""""""""""""""""""""" GENERAL""""""""""""""""""""""""""""""""
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set mouse=""

set hidden
set undofile
set undodir=$HOME/.vim/undo

set undolevels=1000
set undoreload=10000
set scrollback=100000

set lazyredraw
set synmaxcol=128
syntax sync minlines=256

set clipboard+=unnamed,unnamedplus
set number

set shiftwidth=2
set shiftround
set smarttab
set autoindent
set copyindent
set smartindent
set colorcolumn=60,80,100,120
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline

set title
set synmaxcol=150

set lazyredraw
set ttyfast
set regexpengine=1

set splitbelow
set splitright

syntax enable

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

if has('termguicolors')
  set termguicolors
endif

colorscheme one
set background=dark

set spell spelllang=en_gb

set noswapfile

autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" autocmd BufWritePre * lua vim.lsp.buf.formatting()

  "
  " Vim as Git tool
  "
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

  "
  " Fugitive
  "

if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif
noremap <Leader>gs :Gstatus<cr>
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" terminal in insert mode
if has('nvim')
    autocmd TermOpen term://* startinsert
endif

" Terminal emulation
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

"""""""""""""""""""""" PLUGINS """"""""""""""""""""""""""""""""
" startyify
  let g:startify_change_to_vcs_root = 1

" GitGutter
"
  let g:gitgutter_eager = 1    " runs diffs on buffer switch
  let g:gitgutter_enabled = 1  " enables gitgutter (hunks only)
  let g:gitgutter_realtime = 1 " runs diffs when stop writting
  let g:gitgutter_signs = 1    " shows signs on the gutter
  let g:gitgutter_sign_added = '·'
  let g:gitgutter_sign_modified = '·'
  let g:gitgutter_sign_removed = '·'
  let g:gitgutter_sign_removed_first_line = '·'
  let g:gitgutter_sign_modified_removed = '·'
  let g:test#preserve_screen = 1

  noremap <Leader>hn :GitGutterNextHunk<CR>
  noremap <Leader>hp :GitGutterPrevHunk<CR>
  noremap <Leader>hs :GitGutterStageHunk<CR>
  noremap <Leader>hu :GitGutterUndoHunk<CR>
"""""""""""""""""""""""" LSPSAGA """""""""""""""""""""""""""""""""""
  nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
  nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
  vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
  " show hover doc
  nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
  " -- scroll down hover doc or scroll in definition preview
  " nnoremap <silent><leade> K <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
  " -- show signature help
  nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
  " -- rename
  nnoremap <silent>gr <cmd>lua require('lspsaga.rename').rename()<CR>
  " -- preview definition
  nnoremap <silent> gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
  " -- show
  nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
  " -- only show diagnostic if cursor is over the area
  nnoremap <silent><leader>cc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>
  " -- jump diagnostic
  nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
  nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
  nnoremap <silent> ff <cmd>lua vim.lsp.buf.formatting()<CR>
"""""""""""""""""""""""" LSPSAGA """""""""""""""""""""""""""""""""""
" le test
  let test#strategy = 'neovim'
  " FZF override
  function! s:list_buffers()
    redir => list
    silent ls
    redir END
    return split(list, "\n")
  endfunction

  function! s:delete_buffers(lines)
    execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
  endfunction

  command! BD call fzf#run(fzf#wrap({
    \ 'source': s:list_buffers(),
    \ 'sink*': { lines -> s:delete_buffers(lines) },
    \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
    \ }))

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
"""""""""""""""""""""" KEYS """"""""""""""""""""""""""""""""

" Support nested vim
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>

" Fuzzy Finder (review)
  noremap <leader>sc :Rg<CR>
  noremap <C-p> :Files<CR>
  noremap <Leader>o :Buffers<CR>
  noremap <Leader>i :BD<CR>
  noremap <C-c> :bd!<CR>
  noremap <Leader>sg :GitFiles<CR>

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

"Max out the height of the current split
" ctrl + w _
"Max out the width of the current split
" ctrl + w |
"Normalize all split sizes, which is very handy when resizing terminal
" ctrl + w =

" Easy Motion
  map <Leader>f <Plug>(easymotion-bd-f)
  map <Leader>j <Plug>(easymotion-j)
  map <Leader>k <Plug>(easymotion-k)
  nmap s <Plug>(easymotion-s2)

  let g:EasyMotion_use_smartsign_us = 1
  let g:EasyMotion_smartcase = 1

  map  / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)

" le replacer hack
  :nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" le test
  nmap <silent> t<C-n> :TestNearest<CR>
  nmap <silent> t<C-f> :TestFile<CR>
  nmap <silent> t<C-s> :TestSuite<CR>
  nmap <silent> t<C-l> :TestLast<CR>
  nmap <silent> t<C-g> :TestVisit<CR>

" Tab and Shift-Tab in normal mode to navigate buffers
  map <Tab> :bnext<CR>
  map <S-Tab> :bprevious<CR>

" Current directory
  nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Compe

  " inoremap <silent><expr> <C-Space> compe#complete()
  " inoremap <silent><expr> <CR>      compe#confirm('<CR>')
  " inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  " inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  " inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"""""""""""""""""""""" SATUSLINE """"""""""""""""""""""""""""""""
      \
  let g:airline_theme='onedark'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline_section_b = '%{strftime("%c")}'
  let g:airline_section_y = 'BN: %{bufnr("%")}'
  let g:airline_section_x = '%{FugitiveStatusline()}'

"""""""""""""""""""""" PROJECTIONS """"""""""""""""""""""""""""""""

  let g:projectionist_heuristics = {
      \  'mix.exs': {
      \     'lib/**/views/*_view.ex': {
      \       'type': 'view',
      \       'alternate': 'test/{dirname}/views/{basename}_view_test.exs',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View do',
      \         '  use {dirname|camelcase|capitalize}, :view',
      \         'end'
      \       ]
      \     },
      \     'test/**/views/*_view_test.exs': {
      \       'alternate': 'lib/{dirname}/views/{basename}_view.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ViewTest do',
      \         '  use ExUnit.Case, async: true',
      \         '',
      \         '  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View',
      \         'end'
      \       ]
      \     },
      \     'lib/**/controllers/*_controller.ex': {
      \       'type': 'controller',
      \       'alternate': 'test/{dirname}/controllers/{basename}_controller_test.exs',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Controller do',
      \         '  use {dirname|camelcase|capitalize}, :controller',
      \         'end'
      \       ]
      \     },
      \     'test/**/controllers/*_controller_test.exs': {
      \       'alternate': 'lib/{dirname}/controllers/{basename}_controller.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do',
      \         '  use {dirname|camelcase|capitalize}.ConnCase, async: true',
      \         'end'
      \       ]
      \     },
      \     'lib/**/channels/*_channel.ex': {
      \       'type': 'channel',
      \       'alternate': 'test/{dirname}/channels/{basename}_channel_test.exs',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel do',
      \         '  use {dirname|camelcase|capitalize}, :channel',
      \         'end'
      \       ]
      \     },
      \     'test/**/channels/*_channel_test.exs': {
      \       'alternate': 'lib/{dirname}/channels/{basename}_channel.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ChannelTest do',
      \         '  use {dirname|camelcase|capitalize}.ChannelCase, async: true',
      \         '',
      \         '  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel',
      \         'end'
      \       ]
      \     },
      \     'test/**/features/*_test.exs': {
      \       'type': 'feature',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Test do',
      \         '  use {dirname|camelcase|capitalize}.FeatureCase, async: true',
      \         'end'
      \       ]
      \     },
      \     'lib/*.ex': {
      \       'alternate': 'test/{}_test.exs',
      \       'type': 'source',
      \       'template': [
      \         'defmodule {camelcase|capitalize|dot} do',
      \         'end'
      \       ]
      \     },
      \     'test/*_test.exs': {
      \       'alternate': 'lib/{}.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {camelcase|capitalize|dot}Test do',
      \         '  use ExUnit.Case, async: true',
      \         '',
      \         '  alias {camelcase|capitalize|dot}',
      \         'end'
      \       ]
      \     }
      \   }
      \ }

  "Refresh devicons
  if exists('g:loaded_webdevicons')
      call webdevicons#refresh()
  endif
