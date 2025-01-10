-- let $NVIM_TUI_ENABLE_TRUE_COLOR=1
-- if (has("termguicolors"))
--   set termguicolors
-- endif
-- syntax enable
-- syntax sync minlines=256

require("tokyonight").setup({
  -- use the night style
  style = "moon",
  -- disable italic for functions
  styles = {
    functions = {}
  },
-- tokyonight-moon
-- tokyonight-storm
-- tokyonight-day
-- tokyonight-night

  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
  on_colors = function(colors)
    colors.hint = colors.orange
    colors.error = "#ff0000"
  end
})

vim.cmd("colorscheme tokyonight-moon")

require('lualine').setup {
  options = {
    theme = "catppuccin"
  }
}

vim.cmd("hi VirtualColumn guifg=#575268")
