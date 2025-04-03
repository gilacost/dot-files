local actions = require('telescope.actions')
local trouble = require("trouble.sources.telescope")
local telescope = require("telescope")

telescope.setup {
  defaults = {
    cwd = require('lspconfig.util').root_pattern('.git')(vim.fn.getcwd()),
    file_ignore_patterns = {"^%.git/", "node_modules"},
    mappings = {
      i = {
        ["<c-t>"] = trouble.open_with_trouble ,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["<c-t>"] = trouble.open,
        ["q"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,  -- Include dotfiles in the search
    },
  },
}

vim.keymap.set("n", "<Leader>o", "<cmd>Telescope oldfiles<cr>")
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<Leader>sc", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<Leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<Leader>fs", "<cmd>Telescope symbols<cr>")
vim.keymap.set("n", "<C-c>", "<cmd>bd!<cr>", {})
vim.keymap.set("n", "<Leader>n", ":call RenameFile()<CR>")
