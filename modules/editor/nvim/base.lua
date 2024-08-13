--
-- neovim Remote
--

vim.fn.setenv("VISUAL", "nvr -cc split --remote-wait")

--
-- leader
--

vim.g.mapleader = " "
vim.g.maplocalleader = ","

--
-- startyify
--

vim.g.startify_change_to_vcs_root = 1

-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- -- optionally enable 24-bit colour
-- vim.opt.termguicolors = true

--
-- TEST
--

vim.g['test#strategy'] = 'neovim'
vim.keymap.set("n", "t<C-n>", "<Cmd>TestNearest<CR>", { silent = true })
vim.keymap.set("n", "t<C-n>", "<Cmd>TestNearest<CR>", { silent = true })
vim.keymap.set("n", "t<C-f>", "<Cmd>TestFile<CR>", { silent = true })
vim.keymap.set("n", "t<C-s>", "<Cmd>TestSuite<CR>", { silent = true })
vim.keymap.set("n", "t<C-l>", "<Cmd>TestLast<CR>", { silent = true })
vim.keymap.set("n", "t<C-g>", "<Cmd>TestVisit<CR>", { silent = true })

--
-- Tabs
--

vim.keymap.set("n", "nt", "<Cmd>tabnew<Bar>terminal<CR>", { silent = true })
vim.keymap.set("n", "<M-Left>", "gT", {})
vim.keymap.set("n", "<M-Right>", "gt", {})

--
-- splits
--

vim.keymap.set("", "<C-j>", "<C-W>j", { noremap = true })
vim.keymap.set("", "<C-k>", "<C-W>k", { noremap = true })
vim.keymap.set("", "<C-l>", "<C-W>l", { noremap = true })
vim.keymap.set("", "<C-h>", "<C-W>h", { noremap = true })

--
-- resizing
--

vim.keymap.set("n", "<C-n>", "<C-W>|<C-W>_", {})
vim.keymap.set("n", "<C-b>", "<C-W>=", {})

--
-- Easy Motion
--

vim.g.EasyMotion_use_smartsign_us = 1
vim.g.EasyMotion_smartcase = 1

vim.keymap.set("", "<Leader>j", "<Plug>(easymotion-j)")
vim.keymap.set("", "<Leader>k", "<Plug>(easymotion-k)")
vim.keymap.set("n", "s", "<Plug>(easymotion-s2)")

vim.keymap.set("", "/", "<Plug>(easymotion-sn)")
vim.keymap.set("o", "/", "<Plug>(easymotion-tn)")

-- 
-- Toggle NvimTree
-- 
vim.api.nvim_set_keymap("n", "<C-t>", ":NvimTreeFindFileToggle<CR>", { silent = true })

-- 
-- Vim markdown
--

vim.g.vim_markdown_folding_disabled = 1

--
-- Replace All
--

vim.keymap.set("n", "<Leader>r", ":%s/\\<<C-r><C-w>\\>/")

-- Format on save
local format_on_save_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = format_on_save_group,
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})
