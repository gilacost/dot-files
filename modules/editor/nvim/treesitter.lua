vim.lsp.set_log_level 'trace'
-- TREESITTER
-- Using pre-built grammars from Nix, no need for parser_install_dir or auto_install
require'nvim-treesitter.configs'.setup {
  highlight = {
    -- disable = { "markdown", "inline_markdown", "php", "javascript" },
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  ignore_install = {"markdown", "inline_markdown", "php" },

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

  -- Using pre-built grammars from Nix
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
