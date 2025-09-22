-- Harpoon for file bookmarking
require("harpoon").setup({})

-- Harpoon key mappings
vim.keymap.set("n", "<Leader>ha", require("harpoon.mark").add_file)
vim.keymap.set("n", "<Leader>hh", require("harpoon.ui").toggle_quick_menu)
vim.keymap.set("n", "<Leader>1", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<Leader>2", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<Leader>3", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<Leader>4", function() require("harpoon.ui").nav_file(4) end)
vim.keymap.set("n", "<Leader>5", function() require("harpoon.ui").nav_file(5) end)

-- Navigate to next and previous harpoon marks
vim.keymap.set("n", "<Leader>hn", require("harpoon.ui").nav_next)
vim.keymap.set("n", "<Leader>hp", require("harpoon.ui").nav_prev)