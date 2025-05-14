local avante = require('avante')

avante.setup({
    provider = "openai",
    openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",
        timeout = 30000,
        temperature = 0,
    },
    ui = {
        theme = vim.g.colors_name,  -- Use Vim's current color scheme
    },
})

-- Avante highlight fixes
vim.api.nvim_set_hl(0, "AvanteVirtualText", { link = "Comment" })
vim.api.nvim_set_hl(0, "AvantePopupNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "AvantePopupBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- matches transparent backgrounds
vim.keymap.set("n", "<leader>ac", function()
  vim.cmd("AvanteClear")
end, { desc = "Clear Avante chat" })
