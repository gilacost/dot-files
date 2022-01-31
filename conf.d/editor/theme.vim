let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if (has("termguicolors"))
  set termguicolors
endif
syntax enable
syntax sync minlines=256

lua << EOF
local catppuccin = require("catppuccin")

catppuccin.setup {}

--  catppuccino.setup {
--    colorscheme = "dark_catppuccino",
--    transparency = false,
--    styles = {
--      comments = "italic",
--      functions = "italic",
--      keywords = "italic",
--      strings = "NONE",
--      variables = "NONE",
--    },
--    integrations = {
--      treesitter = true,
--      native_lsp = {
--        enabled = true,
--        styles = {
--          errors = "italic",
--          hints = "italic",
--          warnings = "italic",
--          information = "italic"
--        }
--      },
--      lsp_trouble = true,
--      lsp_saga = true,
--      gitsigns = true,
--      telescope = true,
--    }
--  }

vim.cmd[[colorscheme catppuccin]]

EOF
