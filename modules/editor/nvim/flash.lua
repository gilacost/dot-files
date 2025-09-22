-- Flash for enhanced motion
require("flash").setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
  },
  jump = {
    jumplist = true,
    pos = "start",
    history = false,
    register = false,
  },
  label = {
    uppercase = true,
    exclude = "",
    current = true,
    after = true,
    before = false,
    style = "overlay",
  },
  highlight = {
    backdrop = true,
    matches = true,
    priority = 5000,
  },
})

-- Flash key mappings (replaces vim-easymotion)
vim.keymap.set({"n", "x", "o"}, "s", function() require("flash").jump() end)
vim.keymap.set({"n", "x", "o"}, "S", function() require("flash").treesitter() end)
vim.keymap.set("o", "r", function() require("flash").remote() end)
vim.keymap.set({"o", "x"}, "R", function() require("flash").treesitter_search() end)
vim.keymap.set({"c"}, "<c-s>", function() require("flash").toggle() end)