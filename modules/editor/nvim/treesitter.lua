vim.lsp.set_log_level 'trace'
-- TREESITTER
-- Using pre-built grammars from Nix (withAllGrammars), no runtime installation needed
-- Note: nvim-treesitter API changed - now uses require'nvim-treesitter'.setup
-- Highlighting, indent, and other features are now built-in via vim.treesitter
-- No setup needed when using pre-built grammars from Nix

-- require("virt-column").setup({
--   virtcolumn = "80,100"
-- })
-- -- -- TODO tailwind
-- -- -- TODO yaml
-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()
