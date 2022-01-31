pkgs: ''
  lua << EOF
    local lsp = require('lspconfig')
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
      -- Enable completion triggered by <c-x><c-o>
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
      -- Mappings.
      local opts = { noremap=true, silent=true }
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
      buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end
    local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
    for type, icon in pairs(signs) do
      local hl = "LspDiagnosticsSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
    require("trouble").setup()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    lsp.elixirls.setup {
      capabilities = capabilities,
      cmd = { "${pkgs.elixir_ls}/bin/elixir-ls" },
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
    lsp.tailwindcss.setup{
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lsp.bashls.setup{
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lsp.jsonls.setup{
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
          end
        }
      }
    }
    lsp.yamlls.setup{
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        yaml = {
          schemas = {
            kubernetes = "*.yaml",
    --        skaffold = "skaffold.yaml",
          }
        }
      }
    }
  EOF
  autocmd BufWritePre *.ex,*.exs,*.eex,*.leex,*.heex lua vim.lsp.buf.formatting_seq_sync()
''
