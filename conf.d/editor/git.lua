--
-- Vim as Git tool
--

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = {"gitcommit", "gitrebase" , "gitconfig"},
--   command = "set bufhidden=delete"
-- })

-- vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = {"gitcommit", "gitrebase" , "gitconfig"},
--   command = "set bufhidden=delete"
-- })

vim.keymap.set("n", "<leader>gs", ":Gstatus<CR>")

--
-- GitGutter
--

vim.g.gitgutter_eager = 1    " runs diffs on buffer switch
vim.g.gitgutter_enabled = 1  " enables gitgutter (hunks only)
vim.g.gitgutter_realtime = 1 " runs diffs when stop writting
vim.g.gitgutter_signs = 1    " shows signs on the gutter
vim.g.gitgutter_sign_added = '·'
vim.g.gitgutter_sign_modified = '·'
vim.g.gitgutter_sign_removed = '·'
vim.g.gitgutter_sign_removed_first_line = '·'
vim.g.gitgutter_sign_modified_removed = '·'
vim.g['test#preserve_screen'] = 1

vim.keymap.set("n","<Leader>hn",":GitGutterNextHunk<CR>")
vim.keymap.set("n","<Leader>hp",":GitGutterPrevHunk<CR>")
vim.keymap.set("n","<Leader>hs",":GitGutterStageHunk<CR>")
vim.keymap.set("n","<Leader>hu",":GitGutterUndoHunk<CR>")

-- TODO
--
-- GitSigns
--

-- require('gitsigns').setup()

-- Fugitive
--

-- vim.keymap.set("n", "<leader>gs", ":Gstatus<CR>")
