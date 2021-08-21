lua << EOF
vim.lsp.set_log_level 'trace'
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- See `:help vim.lsp.*` for documentation on any vim.lsp functions
end

nvim_lsp['elixirls'].setup {
  cmd = { '/Users/pepo/.nix-profile/bin/elixir-ls' },
  on_attach = on_attach,
}

nvim_lsp['jsonls'].setup {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
      end
    }
  }
}

nvim_lsp['dockerls'].setup{}
nvim_lsp['rnix'].setup{}
nvim_lsp['terraformls'].setup{}
nvim_lsp['vimls'].setup{}

-- TODO styles and JS
-- TODO yaml
-- TODO erlang-ls

local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF
