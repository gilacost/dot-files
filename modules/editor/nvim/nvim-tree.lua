local HEIGHT_RATIO = 0.5 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

return {
  "kyazdani42/nvim-tree.lua",
  event = "VeryLazy",
  config = function()
    vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=None]])
    require("nvim-tree").setup({
      actions = {
        open_file = {
          quit_on_open = true
        }
      },
      disable_netrw = false,
      hijack_netrw = true,
      -- view = {
      --   side = 'right',
      -- },
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2)
                - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      },
      renderer = {
        icons = {
          show = {
            folder_arrow = false,
            folder = true,
            file = true,
            git = true
          }
        }
      },
      filters = {
        dotfiles = false,
      },
    })

    local api = require("nvim-tree.api")

    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd("edit " .. file.fname)
    end)

    vim.api.nvim_create_autocmd("BufEnter", {
      nested = true,
      callback = function()
        -- Only 1 window with nvim-tree left: we probably closed a file buffer
        if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
          -- Required to let the close event complete. An error is thrown without this.
          vim.defer_fn(function()
            -- close nvim-tree: will go to the last hidden buffer used before closing
            api.tree.toggle({ find_file = true, focus = true })
            -- re-open nivm-tree
            api.tree.toggle({ find_file = true, focus = true })
            -- nvim-tree is still the active window. Go to the previous window.
            vim.cmd("wincmd p")
          end, 0)
        end
      end
    })
  end,
}
