local lsp = require('lspconfig')
local opts = { noremap=true, silent=true }

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  vim.keymap.set('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  vim.keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    prefix = "●",
    spacing = 4,
  };
  signs = true,
  underline = false,
  update_in_insert = false,
})

local border = {
  {'╭', "FloatBorder"},
  {'─', "FloatBorder"},
  {'╮', "FloatBorder"},
  {'│', "FloatBorder"},
  {'╯', "FloatBorder"},
  {'─', "FloatBorder"},
  {'╰', "FloatBorder"},
  {'│', "FloatBorder"},
}

vim.diagnostic.config {
  float = { border = "rounded" },
}
vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})

require("trouble").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

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
