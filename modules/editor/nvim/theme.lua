-- let $NVIM_TUI_ENABLE_TRUE_COLOR=1
-- if (has("termguicolors"))
--   set termguicolors
-- endif
-- syntax enable
-- syntax sync minlines=256

-- Read theme from external file that can be changed dynamically
local theme_file = vim.fn.expand("~/.config/nvim-theme")
local theme_style = "day" -- default
local colorscheme = "tokyonight-day" -- default
local lualine_theme = "tokyonight-day" -- default

-- Try to read theme file with error handling
local success, content = pcall(function()
  if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    return lines and lines[1]
  end
  return nil
end)

if success and content and content ~= "" then
  theme_style = content
  colorscheme = "tokyonight-" .. content
  lualine_theme = "tokyonight-" .. content
  print("Using theme: " .. content .. " (colorscheme: " .. colorscheme .. ")")
else
  print("Using default theme: day (file not found or error)")
end

require("tokyonight").setup({
  -- use the configured style
  style = theme_style,
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

vim.cmd("colorscheme " .. colorscheme)

-- Setup lualine with dynamic theme and background fix
require('lualine').setup {
  options = {
    theme = lualine_theme,
    component_separators = '',
    section_separators = ''
  }
}

vim.cmd("hi VirtualColumn guifg=#575268")
