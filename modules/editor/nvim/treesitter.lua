vim.lsp.set_log_level 'trace'
local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
vim.fn.mkdir(parser_install_dir, "p")
-- TREESITTER
require'nvim-treesitter.configs'.setup {
  sync_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },

  parser_install_dir = parser_install_dir,

  auto_install = true,
}

vim.opt.runtimepath:append(parser_install_dir)

require("virt-column").setup({
  virtcolumn = "80,100"
})
-- -- -- TODO tailwind
-- -- -- TODO yaml
-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()
