" nerdtree
let g:NERDTreeWinSize = 24
let g:NERDTreeMinimalUI = 1

" deoplete
let g:deoplete#enable_at_startup = 1
" let g:deoplete#complete_method = 'omnifunc'

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#syntastic#enabled = 0
let g:airline_left_sep= '░'
let g:airline_right_sep= '░'

" ALE - Asynchronous Linting Engine
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1

let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'

let g:ale_elm_make_use_global = 1
let g:ale_elm_format_use_global = 1

let g:ale_linters = {
      \ 'elixir' : ['mix'],
      \ 'vim': ['vimt'],
      \ 'javascript': ['eslint'],
      \ 'scss': ['scss-lint'],
      \ 'typescrypt': ['tslint', 'tsserver']
      \}

let g:ale_fixers = {
      \ 'elixir': ['mix_format', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'typescrypt': ['prettier'],
      \ 'javascript': ['prettier'],
      \ 'scss': ['prettier']
      \}

" vim-javascript
" let g:javascript_plugin_jsdoc = 1
" let g:javascript_plugin_flow = 1

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

" signify (gutter for git)
" let g:signify_vcs_list = ['git']
" let g:signify_sign_change = '~'
" let g:signify_sign_changedelete = '!'
" let g:signify_realtime = 1

" Grepper tools preference
" let g:grepper = { 'tools': ['rg', 'ag', 'git'] }

" Show those languages with syntax highliting inside Markdown
" let g:vim_markdown_folding_level = 2

" neoterm
" let g:neoterm_size = '15%'
" let g:neoterm_autoinsert = 1

" vim-test
" let g:test#strategy = "dispatch"
" let g:test#runner_commands = ['RSpec', 'Mix']

" localvimrc
" let g:localvimrc_persistent = 2

" Nerdtree
" let g:NERDTreeDirArrowExpandable = '+'
" let g:NERDTreeDirArrowCollapsible = '-'
" let NERDTreeIgnore=[
"       \ '_build$[[dir]]',
"       \ 'doc$[[dir]]',
"       \ 'deps$[[dir]]',
"       \ 'elm-stuff$[[dir]]',
"       \ 'node_modules$[[dir]]',
"       \ 'tags$[[file]]',
"       \ 'mix.lock$[[file]]',
"       \ '\.bs\.js$[[file]]'
"       \ ]

