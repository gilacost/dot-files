local actions = require('telescope.actions')
local trouble = require("trouble.providers.telescope")
local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<c-t>"] = trouble.open_with_trouble ,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["<c-t>"] = trouble.open_with_trouble,
        ["q"] = actions.close,
      },
    },
  },
}

vim.keymap.set("n", "<Leader>o", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<Leader>sc", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<Leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<Leader>fs", "<cmd>Telescope symbols<cr>")
vim.keymap.set("n", "<C-c>", "<cmd>bd!<cr>", {})
vim.keymap.set("n", "<Leader>n", ":call RenameFile()<CR>")
