local lsp = require('lspconfig')
local opts = { noremap = true, silent = true }

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
--
-- local on_attach = function(client, bufnr)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>")
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
    vim.keymap.set('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


local signs = { Error = "", Warning = "", Hint = "", Information = "" }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local border = {
  { '╭', "FloatBorder" },
  { '─', "FloatBorder" },
  { '╮', "FloatBorder" },
  { '│', "FloatBorder" },
  { '╯', "FloatBorder" },
  { '─', "FloatBorder" },
  { '╰', "FloatBorder" },
  { '│', "FloatBorder" },
}

lsp.elixirls.setup {
  cmd = { vim.g.lsp_elixir_bin },
  flags = { debounce_text_changes = 150, },
}

-- lsp.lexical.setup{
--    cmd = { vim.g.lsp_elixir_bin },
--   flags = { debounce_text_changes = 150, },
-- }

lsp.erlangls.setup {}

lsp.terraformls.setup {}

lsp.dockerls.setup {}

lsp.vimls.setup {}

lsp.bashls.setup {}

lsp.pyright.setup {}

lsp.rust_analyzer.setup {}

lsp.ansiblels.setup {}

lsp.ts_ls.setup {}

lsp.tflint.setup {}

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
}

-- lsp.tailwindcss.setup {}

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.nixd.setup{}

lsp.jsonls.setup {
  capabilities = capabilities,
}

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = {"*.ex","*.exs","*.eex","*.leex","*.heex"},
--   callback = vim.lsp.buf.formatting_seq_sync
-- })
