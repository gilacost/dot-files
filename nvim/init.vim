set encoding=utf-8 " default character encoding

" Set leader keys before anything else
let mapleader      = "\<SPACE>"
let maplocalleader = ","

filetype off
call plug#begin('~/.config/nvim/plugged')
" test that please
Plug 'janko/vim-test'
" set up working directory for project
Plug 'airblade/vim-rooter'
" Waka waka
Plug 'wakatime/vim-wakatime'
" theme selection
Plug 'mhartington/oceanic-next'
" Remove highlight when move the cursor after a search
Plug 'romainl/vim-cool'
" Vim go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" SQL completion
Plug 'vim-scripts/SQLComplete.vim'
" Folder navigation
Plug 'scrooloose/nerdtree'
" Emmet
Plug 'mattn/emmet-vim'
" elmo
Plug 'elmcast/elm-vim'
" RUST
Plug 'rust-lang/rust.vim'
" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'
" Pope's mailic
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
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
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" startify (recent files)
Plug 'mhinz/vim-startify'
" Git Show diff with style
Plug 'airblade/vim-gitgutter'
" Code formating and go to definition
Plug 'w0rp/ale'
" Tab rename
Plug 'gcmt/taboo.vim' " Tab rename
" Terraform
Plug 'hashivim/vim-terraform'

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
" Fuzzy finder
" Plugin outside ~/.vim/plugged with post-update hook TO BE REMOVED
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Fuzzy Search

call plug#end()
"""""""""""""""""""""" GENERAL""""""""""""""""""""""""""""""""
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
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
  set colorcolumn=60,80,100,120
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
" Theme
" For Neovim 0.1.3 and 0.1.4
  syntax enable
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  set termguicolors
  colorscheme OceanicNext
" Change theme depending on the time of day
  set spell spelllang=en_us
" (Optional)Remove Info(Preview) window
  " set completeopt-=preview
  set noswapfile
" (Optional)Hide Info(Preview) window after completions
  autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" Set JSON on mustached json files
  autocmd BufRead,BufNewFile *.json.mustache set filetype=json.mustache
" Del te git buffer when hidden
  autocmd FileType gitcommit set bufhidden=delete
  autocmd FileType markdown setlocal spell wrap textwidth=80
" EMMET
  let g:user_emmet_install_global = 0
  autocmd FileType html,css EmmetInstall

" Compile elixir ls
  function! ElixirlsCompile()
    let l:commands = join([
      \ 'cd '.$HOME.'/Repos/elixir-ls',
      \ 'asdf install',
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
    autocmd FileType elixir nnoremap <C-]> :ALEGoToDefinitionInVSplit<CR>
    autocmd FileType elixir nnoremap <C-d> :ALEHover<CR>
  augroup END
  nmap <silent> <C-n> <Plug>(ale_previous_wrap)
  nmap <silent> <C-b> <Plug>(ale_next_wrap)
" FZF
  let g:fzf_preview_window = 'right:60%'

" RIPGREP
  let g:rg_binary = '/usr/local/bin/rg'

" startyify
  let g:startify_change_to_vcs_root = 1

" vim-jsx
  let g:jsx_ext_required = 0

" deoplete
"   let g:deoplete#enable_at_startup = 1

  let g:ale_linters = {
  \   'elixir': [],
  \   'ansible': ['ansible-lint'],
  \   'dockerfile': ['hadolint'],
  \   'terraform': ['tflint'],
  \   'yaml': ['prettier'],
  \   'yml': ['prettier'],
  \   'json': ['prettier'],
  \   'css': ['prettier'],
  \   'scss': ['prettier'],
  \   'html': ['tidy', 'prettier'],
  \   'javascript': ['prettier'],
  \   'typescript': ['tsserver', 'tslint'],
  \   'go': ['golint', 'errcheck', 'deadcode', 'vet']
  \}

   let g:ale_fixers = {
   \   '*': ['remove_trailing_lines', 'trim_whitespace'],
   \   'html': ['prettier'],
   \   'elixir': ['mix_format'],
   \   'elm': ['format'],
   \   'rust': ['rustfmt'],
   \   'terraform': ['terraform'],
   \   'yaml': ['prettier'],
   \   'yml': ['prettier'],
   \   'json': ['prettier'],
   \   'css': ['prettier'],
   \   'scss': ['prettier'],
   \   'javascript': ['prettier'],
   \   'typescript': ['prettier'],
   \   'go': [],
   \}
"""""""""""""""""""""""" COC """"""""""""""""""""""""""""""""""""""
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"""""""""""""""""""""" VIM-Go Setup """"""""""""""""""""""""""""""""
" tab width of 4"
  au FileType go set noexpandtab
  au FileType go set shiftwidth=8
  au FileType go set softtabstop=8
  au FileType go set tabstop=8

  " Map keys to GoDecls
  au FileType go nnoremap <buffer> <C-d> :GoDecls<cr>
  au FileType go nnoremap <buffer> <C-g> :GoDeclsDir<cr>
  au FileType go nnoremap <leader>gd :GoDefType<cr>
  "au FileType go nnoremap <Leader>gi :GoSameIdsToggle<CR>
  " let g:go_auto_sameids = 0
  au FileType go nnoremap <Leader>ga :GoAlternate<CR>
  au FileType go nnoremap <Leader>gc :GoCoverageToggle<CR>
  au FileType go nnoremap <Leader>gr :GoRename<CR>

  "Hightlight everything"
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  "let g:go_highlight_function_parameters = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_types = 1
  let g:go_highlight_methods = 1
  "let g:go_auto_sameids = 1
  " let g:go_bin_path = $HOME."/.asdf/installs/golang/1.14.4/go/bin"

  "Auto import dependencies"
  let g:go_fmt_command = "gofmt"

  let g:go_fmt_options = {
      \ 'gofmt': '-s',
      \ }

  "Use this option to auto |:GoFmt| on save
  let g:go_fmt_autosave = 1
  "Disable showing a location list when |'g:go_fmt_command'| fails
  "ALE is in charge of getting the errors on save.
  let g:go_fmt_fail_silently = 1
"""""""""""""""""""""" VIM-Go Setup """"""""""""""""""""""""""""""""

" ALE - Asynchronous Linting Engine
  let g:ale_fix_on_save = 1
  let g:ale_sign_column_always = 1
  let g:ale_lint_on_text_changed = 'always'
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'

  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_elixir_elixir_ls_release = $HOME.'/Repos/elixir-ls/release'

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
"""""""""""""""""""""" KEYS """"""""""""""""""""""""""""""""

" " DEOPLETE
"   inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Support nested vim
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>

" Fuzzy Finder (review)
  noremap <leader>sc :Rg<CR>
  noremap <C-p> :Files<CR>
  noremap <C-o> :Buffers<CR>
  noremap <C-i> :BD<CR>
  noremap <C-c> :bd!<CR>
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
  noremap <leader>zht :new<CR>:terminal<CR>
  noremap <leader>zvt :vnew<CR>:terminal<CR>
  noremap <leader>zh :new<CR>
  noremap <leader>zv :vnew<CR>
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

" Current directory
  nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

"""""""""""""""""""""" STATUSLINE """"""""""""""""""""""""""""""""
      \
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
