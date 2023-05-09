require('neoai').setup{
    models = {
        {
            name = "openai",
            model = "gpt-3.5-turbo",
            params = nil,
        }
    }
}

vim.keymap.set("n","<Leader>ai",":NeoAI<CR>")
-- NeoAIContext
-- vim.keymap.set("n","<Leader>hp",":GitGutterPrevHunk<CR>")
