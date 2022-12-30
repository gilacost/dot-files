local lsp = require('lspconfig')
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'D', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

require("trouble").setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp.elixirls.setup {
  capabilities = capabilities,
  cmd = { vim.g.lsp_elixir_bin },
  flags = { debounce_text_changes = 150, },
  on_attach = on_attach,
}

lsp.erlangls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.terraformls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.rnix.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.dockerls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.vimls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.bashls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.pyright.setup{}

lsp.rust_analyzer.setup{}

lsp.ansiblels.setup{}

-- autocmd BufWritePre *.ex,*.exs,*.eex,*.leex,*.heex lua vim.lsp.buf.format()-
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.ex","*.exs","*.eex","*.leex","*.heex"},
  callback = vim.lsp.buf.formatting_seq_sync
})
