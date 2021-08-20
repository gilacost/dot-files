lua << EOF
vim.lsp.set_log_level 'trace'
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

nvim_lsp['elixirls'].setup {
  cmd = { '/Users/pepo/.nix-profile/bin/elixir-ls' },
  on_attach = on_attach,
}

-- TODO erlang-ls

local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF
