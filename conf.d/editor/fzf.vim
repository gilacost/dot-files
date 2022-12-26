  " FZF
  function! s:list_buffers()
    redir => list
    silent ls
    redir END
    return split(list, "\n")
  endfunction

  command! BD call fzf#run(fzf#wrap({
    \ 'source': s:list_buffers(),
    \ 'sink*': { lines -> s:delete_buffers(lines) },
    \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
    \ }))

  function! s:delete_buffers(lines)
    execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
  endfunction

  noremap <leader>sc :Rg<CR>
  noremap <C-p> :Files<CR>
  noremap <Leader>o :Buffers<CR>
  noremap <Leader>i :BD<CR>
  noremap <C-c> :bd!<CR>
  noremap <Leader>sg :GitFiles<CR>
  " FZF
