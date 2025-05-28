local avante = require("avante")

avante.setup({
  provider = "openai",
  vendors = {
    openai = {
      endpoint = "https://api.openai.com/v1",
      api_key_name = "OPENAI_API_KEY",
      model = "gpt-4o",
      max_tokens = 8192,
    },
  },
  auto_suggestions_provider = "openai",
  behaviour = {
    auto_set_keymaps = false,
  },
  hints = {
    enabled = false,
  },
  -- Optional window config
  -- windows = {
  --   ask = {
  --     focus_on_apply = "theirs",
  --   },
  --   edit = {
  --     border = "rounded",
  --     start_insert = true,
  --   },
  -- },

  -- ⚠️ Make sure your system_prompt returns a string
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,

  -- ✅ Now a table (not a function)
  custom_tools = {
    require("mcphub.extensions.avante").mcp_tool(),
  },

  disabled_tools = {
    "list_files",
    "search_files",
    "read_file",
    "create_file",
    "rename_file",
    "delete_file",
    "create_dir",
    "rename_dir",
    "delete_dir",
    "bash",
  },
})
