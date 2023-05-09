local termGroup = vim.api.nvim_create_augroup("Terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = termgroup,
  callback = function()
    vim.cmd([[
      setlocal nospell
      setlocal nonumber
      setlocal scrollback=1000
      setlocal signcolumn=no
      startinsert
    ]])
  end
})

vim.api.nvim_create_autocmd("TermEnter", {
  group = termgroup,
  callback = function()
    vim.cmd([[
      setlocal scrolloff=0
    ]])
  end
})

vim.api.nvim_create_autocmd("TermLeave", {
  group = termgroup,
  command = "setlocal scrolloff=10"
})

vim.keymap.set("n", "<leader>zz", ":terminal<CR>")
vim.keymap.set("n", "<leader>zh", ":new<CR>:terminal<CR>")
vim.keymap.set("n", "<leader>zv", ":vnew<CR>:terminal<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-v><Esc>", "<Esc>")

vim.cmd("highlight! link TermCursor Cursor")
vim.cmd("highlight! TermCursorNC guibg=teal guifg=white ctermbg=1 ctermfg=15")
