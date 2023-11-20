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
  vim.keymap.set('n', '<Leader>h', vim.diagnostic.open_float(), bufopts)
  -- vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>")
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
end

local signs = { Error = "", Warning = "", Hint = "", Information = "" }

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

lsp.pyright.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.rust_analyzer.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.ansiblels.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.tsserver.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.tflint.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}

lsp.yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        ["https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json"] = "docker-compose*.yaml",
      },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
}

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = {"*.ex","*.exs","*.eex","*.leex","*.heex"},
--   callback = vim.lsp.buf.formatting_seq_sync
-- })
