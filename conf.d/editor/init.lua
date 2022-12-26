--
-- NeoVim Remote
--

vim.fn.setenv("VISUAL", "nvr -cc split --remote-wait")

--
-- leader
--
-- Set leader keys before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- TODO ---
-- " autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
-- " autocmd InsertLeave * if pumvisible() == 0|pclose|endif
-- TODO ---

-- startyify
vim.g.startify_change_to_vcs_root = 1
-- " SHOULD I MOVE THIS TO BASE (SETS)

-- TODO ---
-- " autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- " highlight white spaces in RED
-- highlight ExtraWhitespace guibg=grey
-- au ColorScheme * highlight ExtraWhitespace guibg=grey
-- au BufEnter * match ExtraWhitespace /\s\+$/
-- au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
-- au InsertLeave * match ExtraWhiteSpace /\s\+$/
-- TODO ---

---
--- TEST
---
vim.g['test#strategy'] = 'neovim'
vim.keymap.set("n", "t<C-n>", "<Cmd>TestNearest<CR>", { silent = true })
vim.keymap.set("n", "t<C-n>", "<Cmd>TestNearest<CR>", { silent = true })
vim.keymap.set("n", "t<C-f>", "<Cmd>TestFile<CR>", { silent = true })
vim.keymap.set("n", "t<C-s>", "<Cmd>TestSuite<CR>", { silent = true })
vim.keymap.set("n", "t<C-l>", "<Cmd>TestLast<CR>", { silent = true })
vim.keymap.set("n", "t<C-g>", "<Cmd>TestVisit<CR>", { silent = true })


--- random functions
-- function! Repeat()
--   let times = input("Count: ")
--   let char  = input("Char: ")
--   exe ":normal a" . repeat(char, times)
-- endfunction

-- " Rename current file
-- function! RenameFile()
--     let old_name = expand('%')
--     let new_name = input('New file name: ', expand('%'), 'file')
--     if new_name != '' && new_name != old_name
--         exec ':saveas ' . new_name
--         exec ':silent !rm ' . old_name
--         redraw!
--     endif
-- endfunction

-- """""""""""""""""""""" MAPPINGS """"""""""""""""""""""""""""""""

-- " quick list and location list
-- nnoremap <leader>qo :copen<CR>
-- nnoremap <leader>qc :cclose<CR>

-- " Rename File
-- map <leader>n :call RenameFile()<cr>

-- " Show undo list
-- nnoremap <leader>u :GundoToggle<CR>

--- Tabs
vim.keymap.set("n", "nt", "<Cmd>tabnew<CR>terminal<CR>", { silent = true })
vim.keymap.set("n", "<M-Left>", "gT", {})
vim.keymap.set("n", "<M-Right>", "gt", {})

--- splits
vim.keymap.set("", "<C-j>", "<C-W>j", { noremap = true })
vim.keymap.set("", "<C-k>", "<C-W>k", { noremap = true })
vim.keymap.set("", "<C-l>", "<C-W>l", { noremap = true })
vim.keymap.set("", "<C-h>", "<C-W>h", { noremap = true })

-- " resizing
vim.keymap.set("n", "<C-n>", "<C-W>|<C-W>_", {})
vim.keymap.set("n", "<C-b>", "<C-W>=", {})

-- " Easy Motion
-- map <Leader>f <Plug>(easymotion-bd-f)
-- map <Leader>j <Plug>(easymotion-j)
-- map <Leader>k <Plug>(easymotion-k)
-- nmap s <Plug>(easymotion-s2)

-- let g:EasyMotion_use_smartsign_us = 1
-- let g:EasyMotion_smartcase = 1
-- let g:vim_markdown_folding_disabled = 1

-- " replace all
-- :nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

-- " Tab and Shift-Tab in normal mode to navigate buffers
-- map <Tab> :bnext<CR>
-- map <S-Tab> :bprevious<CR>

-- " Git
-- nnoremap <leader>nh :GitGutterNextHunk<CR>
-- nnoremap <leader>ph :GitGutterPrevHunk<CR>
-- nnoremap <leader>sh :GitGutterStageHunk<CR>
-- nnoremap <leader>gc :Git commit<CR>
-- nnoremap <leader>gp :Git push<CR>

-- """""""""""""""""""""" SATUSLINE """"""""""""""""""""""""""""""""
-- let g:airline_theme='onedark'
-- let g:airline#extensions#tabline#enabled = 1
-- let g:airline_powerline_fonts = 1
-- let g:airline_section_b = '%{strftime("%c")}'
-- let g:airline_section_y = 'BN: %{bufnr("%")}'
-- let g:airline_section_x = '%{FugitiveStatusline()}'

-- "Refresh devicons
-- if exists('g:loaded_webdevicons')
--     call webdevicons#refresh()
-- endif

-- """""""""""""""""""""format on save""""""""""""""""""""""""""""""
-- " autocmd BufWritePre * lua vim.lsp.buf.format()
-- au BufNewFile,BufRead rebar.config setf erlang
-- au BufNewFile,BufRead *app.src setf erlang
-- " au BufNewFile,BufRead *heex setf elixir
-- """""""""""""""""""""format on save""""""""""""""""""""""""""""""

-- """""""""""""""""""""LSP TROUBLE"""""""""""""""""""""""""""""""""
-- nnoremap <leader>xx <cmd>TroubleToggle<cr>
-- nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
-- nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
-- nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
-- nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
-- nnoremap gR <cmd>TroubleToggle lsp_references<cr>
-- """""""""""""""""""""LSP TROUBLE"""""""""""""""""""""""""""""""""

-- let g:neoformat_prettier = {
--   \ 'exe': '/etc/profiles/per-user/pepo/bin/prettier',
--   \ 'args': ['--stdin-filepath', '"%:p"'],
--   \ 'stdin': 1,
--   \ }

-- let g:neoformat_enabled_elixir = []
-- let g:neoformat_javascript_prettier = g:neoformat_prettier
-- let g:neoformat_enabled_javascript = ['prettier']
-- let g:neoformat_json_prettier = g:neoformat_prettier
-- let g:neoformat_enabled_json = ['prettier']
-- let g:neoformat_css_prettier = g:neoformat_prettier
-- let g:neoformat_enabled_css = ['prettier']
-- let g:neoformat_typescript_prettier = g:neoformat_prettier
-- let g:neoformat_enabled_typescript = ['prettier']
-- let g:neoformat_yaml_prettier = g:neoformat_prettier
-- let g:neoformat_enabled_yaml = ['prettier']

-- function! ToggleGenericFormat()
--   let g:neoformat_basic_format_retab = !g:neoformat_basic_format_retab
--   let g:neoformat_basic_format_trim = !g:neoformat_basic_format_retab
-- endfunction

vim.g.neoformat_basic_format_retab = 1
vim.g.neoformat_basic_format_trim = 1

local augroup = vim.api.nvim_create_augroup('fmt', {clear = true})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = augroup,
  -- command = 'try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry'
  command = 'undojoin | Neoformat'
})
