local actions = require('telescope.actions')
local trouble = require("trouble.sources.telescope")
local telescope = require("telescope")
local builtin = require('telescope.builtin')

-- Helper function to find git root or fallback to cwd
local function get_git_root()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 then
    return root
  end
  return vim.fn.getcwd()
end

telescope.setup {
  defaults = {
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

-- Smart find files - searches from git root if in a git repo, otherwise from cwd
vim.keymap.set("n", "<C-p>", function()
  builtin.find_files({ cwd = get_git_root() })
end, { desc = "Find files in git root" })

-- Smart live grep - searches from git root if in a git repo, otherwise from cwd
vim.keymap.set("n", "<Leader>sc", function()
  builtin.live_grep({ cwd = get_git_root() })
end, { desc = "Live grep in git root" })

-- Additional useful mappings
vim.keymap.set("n", "<Leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<Leader>fs", "<cmd>Telescope symbols<cr>")

-- Search files from current directory (not git root) when you need it
vim.keymap.set("n", "<Leader>ff", function()
  builtin.find_files({ cwd = vim.fn.getcwd() })
end, { desc = "Find files in current directory" })

-- Search in current directory (not git root)
vim.keymap.set("n", "<Leader>ss", function()
  builtin.live_grep({ cwd = vim.fn.getcwd() })
end, { desc = "Live grep in current directory" })

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
