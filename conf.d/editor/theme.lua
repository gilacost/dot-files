-- let $NVIM_TUI_ENABLE_TRUE_COLOR=1
-- if (has("termguicolors"))
--   set termguicolors
-- endif
-- syntax enable
-- syntax sync minlines=256

local catppuccin = require("catppuccin")

catppuccin.setup {}

vim.cmd("colorscheme catppuccin")

require('lualine').setup {
  options = {
    theme = "catppuccin"
  }
}

vim.cmd("hi VirtualColumn guifg=#575268")
