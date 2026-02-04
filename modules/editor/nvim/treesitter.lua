vim.lsp.set_log_level 'trace'
-- TREESITTER
-- Using pre-built grammars from Nix (withAllGrammars)
-- Configure nvim-treesitter to enable highlighting
require('nvim-treesitter').setup {
  -- Point to where Nix installs the parsers
  install_dir = vim.fn.stdpath('data') .. '/site'
}

-- Enable tree-sitter based syntax highlighting for all supported languages
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype

    -- Check if a parser exists for this filetype
    local has_parser = pcall(vim.treesitter.language.get_lang, ft)

    if has_parser then
      vim.treesitter.start(buf, ft)
    end
  end,
})

-- require("virt-column").setup({
--   virtcolumn = "80,100"
-- })
-- -- -- TODO tailwind
-- -- -- TODO yaml
-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()
