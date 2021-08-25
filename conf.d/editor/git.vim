" GIT
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

noremap <Leader>gs :Gstatus<cr>
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
" GitGutter

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
" GIT
