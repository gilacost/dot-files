lua << EOF
vim.lsp.set_log_level 'trace'
local nvim_lsp = require 'lspconfig'

nvim_lsp['elixirls'].setup {
  cmd = { '/Users/pepo/.nix-profile/bin/elixir-ls' },
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

vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

-- TODO styles and JS
-- TODO yaml
-- TODO erlang-ls

local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF
