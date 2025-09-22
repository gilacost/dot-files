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

-- Existing mappings
vim.keymap.set("n", "<Leader>o", "<cmd>Telescope oldfiles<cr>")
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<Leader>sc", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<Leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<Leader>fs", "<cmd>Telescope symbols<cr>")
vim.keymap.set("n", "<C-c>", "<cmd>bd!<cr>", {})
vim.keymap.set("n", "<Leader>n", ":call RenameFile()<CR>")

-- Enhanced project navigation
vim.keymap.set("n", "<Leader>pf", "<cmd>Telescope find_files cwd=~/Repos<cr>") -- Find files in projects
vim.keymap.set("n", "<Leader>ps", "<cmd>Telescope live_grep cwd=~/Repos<cr>") -- Search in projects  
vim.keymap.set("n", "<Leader>pb", "<cmd>Telescope buffers<cr>") -- Project buffers
vim.keymap.set("n", "<Leader>pp", function() -- Project picker
  require'telescope.builtin'.find_files({
    prompt_title = "< Projects >",
    cwd = "~/Repos",
    find_command = {"fd", "--type", "d", "--max-depth", "2"},
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("cd " .. selection.path)
        vim.cmd("Telescope find_files")
      end)
      
      return true
    end,
  })
end)
