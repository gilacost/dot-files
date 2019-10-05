set encoding=utf-8 " default character encoding

" Set leader keys before anything else
let mapleader      = "\<SPACE>"
let maplocalleader = ","

filetype off
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')
" test that please
Plug 'janko/vim-test'
" set up working directory for project
Plug 'airblade/vim-rooter'
" Oceanic Next theme and theme selection
Plug 'mhartington/oceanic-next'
" ruby on fails
" Plug 'vim-ruby/vim-ruby'
" Remove highlight when move the cursor after a search
Plug 'romainl/vim-cool'
" SQL completion
Plug 'vim-scripts/SQLComplete.vim'
" Folder navigation
Plug 'scrooloose/nerdtree'
" elmo
Plug 'elmcast/elm-vim'
" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'
" Fuzzy finder
" Plugin outside ~/.vim/plugged with post-update hook TO BE REMOVED
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Fuzzy Search
" Plug 'cloudhead/neovim-fuzzy'
" Rip grep
" Plug 'jremmen/vim-ripgrep'
" Pope's mailic
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
" " elixir and phoenix stuff
" Plug 'elixir-editors/vim-elixir'
"fancy icons
Plug 'ryanoasis/vim-devicons'
" vim dispatch allows to run external commands asynchronously
Plug 'tpope/vim-dispatch'
" only for hackers
Plug 'easymotion/vim-easymotion'
" neovim dispatch adapter
Plug 'radenling/vim-dispatch-neovim'
" fancy status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Org mode
Plug  'jceb/vim-orgmode'
"Dark powered asynchronous completion framework for neovim/Vim8
" Use tab for completion if visible if not normal tab
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" startify (recent files)
Plug 'mhinz/vim-startify'
" Git Show diff with style
Plug 'airblade/vim-gitgutter'
" Code formating and go to definition
Plug 'w0rp/ale'
" Tab rename
Plug 'gcmt/taboo.vim' " Tab rename
call plug#end()
"""""""""""""""""""""" GENERAL""""""""""""""""""""""""""""""""
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --vimgrep --glob "!.git/*"'

  "
  set mouse=""
  " Persistent undo
  set hidden
  set undofile
  set undodir=$HOME/.vim/undo

  set undolevels=1000
  set undoreload=10000
" redraw
  set lazyredraw
  set synmaxcol=128
  syntax sync minlines=256
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
  " set cursorcolumn
  set title "set the title of the iterm tab
  set synmaxcol=150
"syntax sync minlines=256
  set lazyredraw
  set ttyfast
  set regexpengine=1
" More natural splits
  set splitbelow          " Horizontal split below current.
  set splitright          " Vertical split to right of current.
" Show non visual chars
" non-printable character display settings when :set list
    " set noswapfile " Disable Swap Files
" Theme
  syntax enable
  set termguicolors     " enable true colors support
"Change theme depending on the time of day
  colorscheme OceanicNext
  set spell spelllang=en_us
" Status line syntastic
  set statusline+=%#warningmsg#
  set statusline+=%*
  " set statusline+=%{FugitiveStatusline()}
" (Optional)Remove Info(Preview) window
  set completeopt-=preview
" (Optional)Hide Info(Preview) window after completions
  autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" Set JSON on mustached json files
  autocmd BufRead,BufNewFile *.json.mustache set filetype=json.mustache
" Del te git buffer when hidden
  autocmd FileType gitcommit set bufhidden=delete
  autocmd FileType markdown setlocal spell wrap textwidth=80
" RG
  command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)
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
" Compile elixir ls
  function! ElixirlsCompile()
    let l:commands = join([
      \ 'asdf install',
      \ 'cd /Users/pepo/Repos/elixir-ls',
      \ 'mix local.hex --force',
      \ 'mix local.rebar --force',
      \ 'mix deps.get',
      \ 'mix compile',
      \ 'mix elixir_ls.release'
      \ ], '&&')

    echom '>>> Compiling elixirls'
    silent call system(l:commands)
    echom '>>> elixirls compiled'
  endfunction
" Linter status
  function! LinterStatus() abort
      let l:counts = ale#statusline#Count(bufnr('%'))

      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors

      return l:counts.total == 0 ? 'OK' : printf(
      \   '%dW %dE',
      \   all_non_errors,
      \   all_errors
      \)
  endfunction
" terminal in insert mode
  if has('nvim')
      autocmd TermOpen term://* startinsert
  endif

  highlight ExtraWhitespace ctermbg=red guibg=red
  au ColorScheme * highlight ExtraWhitespace guibg=red
  au BufEnter * match ExtraWhitespace /\s\+$/
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match ExtraWhiteSpace /\s\+$/

"""""""""""""""""""""" PLUGINS """"""""""""""""""""""""""""""""
" ALE
  augroup elixir
    nnoremap <leader>ef :! elixir %<CR>
    autocmd FileType elixir nnoremap <C-]> :ALEGoToDefinition<CR>
    autocmd FileType elixir nnoremap <C-d> :ALEHover<CR>
  augroup END
  nmap <silent> <C-n> <Plug>(ale_previous_wrap)
  nmap <silent> <C-b> <Plug>(ale_next_wrap)
" RIPGREP
  let g:rg_binary = '/usr/local/bin/rg'

" startyify
  let g:startify_change_to_vcs_root = 1

" vim-jsx
  let g:jsx_ext_required = 0

" deoplete
  let g:deoplete#enable_at_startup = 1

" ALE - Asynchronous Linting Engine
  let g:ale_fix_on_save = 1
  let g:ale_sign_column_always = 1
  " let g:ale_lint_on_text_changed = 'never'
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'

  let g:ale_linters = {}
  let g:ale_linters.scss = ['stylelint']
  let g:ale_linters.css = ['stylelint']
  let g:ale_linters.elixir = ['elixir-ls']
  let g:ale_linters.ruby = ['rubocop', 'ruby', 'solargraph']

  let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
  let g:ale_fixers.javascript = ['eslint']
  let g:ale_fixers.scss = ['stylelint']
  let g:ale_fixers.css = ['stylelint']
  let g:ale_fixers.elm = ['format']
  let g:ale_fixers.ruby = ['rubocop']
  let g:ale_ruby_rubocop_executable = 'bundle'
  let g:ale_fixers.elixir = ['mix_format']
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_elixir_elixir_ls_release = '/Users/pepo/Repos/elixir-ls/release'

  " Write this in your vimrc file
  let g:ale_set_loclist = 0
  let g:ale_set_quickfix = 1

" vim-javascript
  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 1

" Elm Cast
  let g:elm_detailed_complete = 1
  let g:elm_format_autosave = 1

" Disable polyglot in favor of real language packs
" Polyglot is great but it doesn't activate all the functionalities for all
" languages in order to make it load fast.
  let g:polyglot_disabled = ['elm', 'markdown']

" Ultisnips
  let g:UltiSnipsSnippetsDir = $HOME.'/.config/nvim/snips'
  let g:UltiSnipsSnippetDirectories = ["snips", "priv_snips", "UltiSnips" ]
  let g:UltiSnipsEditSplit = "vertical"

" Show those languages with syntax highliting inside Markdown
  let g:vim_markdown_folding_level = 2

" le test
  let test#strategy = 'neovim'
"""""""""""""""""""""" KEYS """"""""""""""""""""""""""""""""

" DEOPLETE
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Support nested vim
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>

" Fuzzy Finder (review)
  noremap <leader>sc :Rg<CR>
  noremap <C-p> :FZF<CR>
  " nnoremap <C-p> :FuzzyOpen<CR>
  noremap <Leader>sg :GitFiles<CR>

" Edit and reload vimrc
  nnoremap <leader>ve :edit $MYVIMRC<CR>
  nnoremap <leader>vr :source $MYVIMRC<CR>

" Errors list
  nnoremap <leader>lo :ALEDetail<CR>
  nnoremap <leader>ln :ALENext<CR>

" quick list and location list
  nnoremap <leader>qo :copen<CR>
  nnoremap <leader>qc :cclose<CR>

" Exit vim
  nnoremap <silent><leader>qq :qall<CR>

" Rename File
  map <leader>n :call RenameFile()<cr>

" Terminal emulation
  augroup terminal
  autocmd TermOpen * setlocal nospell
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal scrollback=1000
  augroup END
  noremap <leader>zz :terminal<CR>
  noremap <leader>zh :new<CR>:terminal<CR>
  noremap <leader>zv :vnew<CR>:terminal<CR>
  tnoremap <Esc> <C-\><C-n>

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
"Max out the height of the current split
" ctrl + w _
"Max out the width of the current split
" ctrl + w |
"Normalize all split sizes, which is very handy when resizing terminal
" ctrl + w =

" Easy Motion
  map  <Leader>f <Plug>(easymotion-bd-f)
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

" ALE
"

"""""""""""""""""""""" STATUSLINE """"""""""""""""""""""""""""""""
  let g:airline_theme='oceanicnext'
  let g:airline#extensions#ale#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline_section_b = '%{strftime("%c")}'
  let g:airline_section_y = 'BN: %{bufnr("%")}'
  let g:airline_section_x = '%{FugitiveStatusline()}'
  let g:airline_section_c = '%{LinterStatus()}'

"""""""""""""""""""""" PROJECTIONS """"""""""""""""""""""""""""""""

let g:projectionist_heuristics = {
      \  "mix.exs": {
      \    "lib/*.ex": {
      \      "type": "lib",
      \      "alternate": "test/{}_test.exs"
      \    },
      \    "test/*_test.exs": {
      \      "type": "test",
      \      "alternate": "lib/{}.ex"
      \    },
      \    "mix.exs": {
      \      "type": "mix"
      \    },
      \    "config/config.exs": {
      \      "type": "config"
      \    }
      \  }
      \ }

  "Refresh devicons
  if exists('g:loaded_webdevicons')
      call webdevicons#refresh()
  endif
