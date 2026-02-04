vim.lsp.set_log_level 'trace'
-- TREESITTER
-- Using pre-built grammars from Nix (withAllGrammars), no runtime installation needed
require('nvim-treesitter.configs').setup {
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

  -- Disable auto-install since Nix provides all grammars
  auto_install = false,
  sync_install = false,
}

-- require("virt-column").setup({
--   virtcolumn = "80,100"
-- })
-- -- -- TODO tailwind
-- -- -- TODO yaml
-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()
