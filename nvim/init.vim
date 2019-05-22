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
" erlang no chinese shit
Plug 'vim-erlang/vim-erlang-compiler'
" dracula theme and theme selection
Plug 'dracula/vim', { 'as': 'dracula' }
" ruby on fails
 Plug 'vim-ruby/vim-ruby'
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
" Pope's mailic
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-vinegar'
" " elixir and phoenix stuff
Plug 'elixir-editors/vim-elixir'
" vim dispatch allows to run external commands asynchronously
Plug 'tpope/vim-dispatch'
" only for hackers
" Plug 'easymotion/vim-easymotion'
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
" Git
" " Show diff with style
Plug 'mhinz/vim-signify'
" Code formating and go to definition
Plug 'w0rp/ale'
call plug#end()
"""""""""""""""""""""" GENERAL""""""""""""""""""""""""""""""""
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    let $FZF_DEFAULT_COMMAND = 'ag -g ""'
    set mouse=""
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
" Delete git buffer when hidden
    autocmd FileType gitcommit set bufhidden=delete
    autocmd FileType markdown setlocal spell wrap textwidth=80
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
    " set termguicolors
    " set background=dark
    color dracula
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
"""""""""""""""""""""" PLUGINS """"""""""""""""""""""""""""""""
" " startyify
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
let g:ale_elm_make_use_global = 1
let g:ale_elm_format_use_global = 1
let g:ale_linters = {
      \ 'elixir': ['mix'],
      \ 'javascript': ['eslint'],
      \ 'scss': ['scss-lint'],
      \}
let g:ale_fixers = {
      \ 'elixir': ['mix_format', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['prettier'],
      \ 'scss': ['prettier']
      \}

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

" " signify (gutter for git)
let g:signify_vcs_list = ['git']
let g:signify_sign_change = '~'
let g:signify_sign_changedelete = '!'
let g:signify_realtime = 1

" Show those languages with syntax highliting inside Markdown
let g:vim_markdown_folding_level = 2
"""""""""""""""""""""" KEYS """"""""""""""""""""""""""""""""

" DEOPLETE
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Signify
  nmap <leader>sd :SignifyDiff<CR>

" Fuzzy Finder (review)
  noremap <leader>sc :Ag<CR>
  noremap <C-p> :FZF<CR>
  noremap <Leader>sg :GitFiles<CR>

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

"" Buffer Navigation
  :nnoremap <C-k> :bnext<CR>
  :nnoremap <C-l> :bprevious<CR>

" Terminal emulation
augroup terminal
autocmd TermOpen * setlocal nospell
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal scrollback=1000
augroup END
nnoremap <leader>zz :terminal<CR>
nnoremap <leader>zh :new<CR>:terminal<CR>
nnoremap <leader>zv :vnew<CR>:terminal<CR>
tnoremap <Esc> <C-\><C-n>

" Show undo list
" nnoremap <leader>u :GundoToggle<CR>

" Tabs
noremap <silent> nt :tabnew<CR>
noremap <M-Left> gT
noremap <M-Right> gt
" Remap arrow keys to change between buffers
noremap <C-S-Up> <C-w>k
noremap <C-S-Down> <C-w>j
noremap <C-S-Left> <C-w>h
noremap <C-S-Right> <C-w>l

" AG
noremap <Leader>sc :Ag<CR>
noremap <Leader>lc :lclose<cr>
noremap <Leader>lo :lopen<cr>

" quick list and location list
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

"""""""""""""""""""""" STATUSLINE """"""""""""""""""""""""""""""""
let g:airline_theme='dracula'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'

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

