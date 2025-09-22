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
vim.g.startify_change_to_dir = 0  -- Don't change to file's directory

-- Auto change directory to VCS root when opening files
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "terminal" and vim.bo.buftype ~= "nofile" then
      -- Try to find git root
      local git_root = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel 2>/dev/null")
      git_root = git_root:gsub("\n", "")
      if vim.v.shell_error == 0 and git_root ~= "" then
        vim.cmd("silent! lcd " .. git_root)
      end
    end
  end,
})

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

-- Save on leave if not terminal
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "terminal" then
      vim.cmd("silent! w")
    end
  end,
})

-- -- Function to close hidden, unmodified buffers not loaded in any visible tab
-- local function close_hidden_buffers()
--   for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
--     if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
--       -- Check if the buffer is hidden (not displayed in any window)
--       local is_hidden = vim.fn.bufwinnr(bufnr) == -1
--       local is_displayed_in_any_tab = false

--       -- Loop through all tab handles and their windows to check if the buffer is displayed
--       for _, tab_handle in ipairs(vim.api.nvim_list_tabpages()) do
--         for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab_handle)) do
--           if vim.api.nvim_win_get_buf(win) == bufnr then
--             is_displayed_in_any_tab = true
--             break
--           end
--         end
--         if is_displayed_in_any_tab then break end
--       end

--       -- Delete the buffer if it's hidden, not displayed in any tab, and unmodified
--       if is_hidden and not is_displayed_in_any_tab and not vim.bo[bufnr].modified then
--         vim.api.nvim_buf_delete(bufnr, { force = true })
--       end
--     end
--   end
-- end

-- -- Autocommand to run the function on each buffer switch
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*",
--   callback = close_hidden_buffers,
-- })
