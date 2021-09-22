lua << EOF
local actions = require('telescope.actions')
local trouble = require("trouble.providers.telescope")
local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<c-t>"] = trouble.open_with_trouble ,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["<c-t>"] = trouble.open_with_trouble,
        ["q"] = actions.close,
      },
    },
  },
}
EOF

noremap <Leader>o <cmd>Telescope buffers<cr>
noremap <C-p> <cmd>Telescope find_files<cr>
noremap <Leader>sc <cmd>Telescope live_grep<cr>
noremap <Leader>fh <cmd>Telescope help_tags<cr>
noremap <Leader>fs <cmd>Telescope symbols<cr>
