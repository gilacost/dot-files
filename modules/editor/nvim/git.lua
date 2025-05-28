--
-- Vim as Git tool
--

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"gitcommit", "gitrebase" , "gitconfig"},
  command = "set bufhidden=delete"
})

vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"gitcommit", "gitrebase" , "gitconfig"},
  command = "set bufhidden=delete"
})

--
-- GitGutter
--

vim.g.gitgutter_eager = 1 
vim.g.gitgutter_enabled = 1
vim.g.gitgutter_realtime = 1
vim.g.gitgutter_signs = 1
vim.g['test#preserve_screen'] = 1

vim.keymap.set("n", "]h", ":GitGutterNextHunk<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[h", ":GitGutterPrevHunk<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gs", ":GitGutterStageHunk<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gu", ":GitGutterUndoHunk<CR>", { noremap = true, silent = true })

-- TODO
--
-- GitSigns
--

-- require('gitsigns').setup()
