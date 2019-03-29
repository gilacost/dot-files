" " startyify
" let g:startify_change_to_vcs_root = 1

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
