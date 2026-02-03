# Ghostty + LazyVim AI-Oriented Dev Setup Transition Plan

**Created:** 2025-12-30
**Strategy:** Gradual migration (terminal first, then editor)
**Focus:** Speed, Context, and Workflow for AI-assisted development

---

## Phase 1: Ghostty Terminal Setup

### Goal
Replace Kitty with Ghostty while maintaining theme consistency and adding shader effects.

### Nix Configuration
Add to your `flake.nix` inputs and home-manager packages:
```nix
# In flake.nix inputs:
ghostty.url = "github:ghostty-org/ghostty";

# In home.nix packages:
pkgs.ghostty  # or inputs.ghostty.packages.${system}.default
```

### Ghostty Configuration (`~/.config/ghostty/config`)

```conf
# Font - keep your Iosevka
font-family = "Iosevka Nerd Font Mono"
font-size = 16

# Theme - Tokyo Night Moon (matching current)
background = #222436
foreground = #c8d3f5
cursor-color = #c8d3f5
selection-background = #2d3f76
selection-foreground = #c8d3f5

# Performance
shell-integration = detect
shell-integration-features = no-cursor,no-sudo,no-title

# Background effects (for blur shader)
background-opacity = 0.95
background-blur-radius = 20

# Keybindings (matching your Kitty setup)
keybind = alt+equal=increase_font_size:2
keybind = alt+minus=decrease_font_size:2
keybind = alt+backspace=reset_font_size
keybind = cmd+h=hide
keybind = cmd+q=quit

# Shader configuration
custom-shader = ~/.config/ghostty/shaders/crt.glsl
custom-shader = ~/.config/ghostty/shaders/blur.glsl
custom-shader = ~/.config/ghostty/shaders/color-grading.glsl
```

### Shader Setup

Create `~/.config/ghostty/shaders/` directory and add three shaders:

#### 1. CRT Effect (`crt.glsl`)
Source: [ghostty-shaders repo](https://github.com/thijskok/ghostty-shaders)
- Subtle scanlines
- Phosphor glow
- Light flicker effect
- Chromatic aberration

#### 2. Blur Effect (`blur.glsl`)
- Gaussian blur for transparency
- macOS-style background integration

#### 3. Color Grading (`color-grading.glsl`)
Custom shader for:
- Enhanced contrast for code readability
- Warmer/cooler tones toggle
- Syntax highlighting boost

### Testing Phase
- Run Ghostty alongside Kitty for 1 week
- Verify shader performance (shouldn't affect input latency)
- Test with heavy output (build logs, test runners)
- Confirm theme matches across terminal and nvim

---

## Phase 2: Audit Current Neovim Setup

### Current Plugins (from your config)

**Keep These (Essential):**
- `telescope.nvim` - fuzzy finding (essential for LazyVim)
- `nvim-treesitter` - syntax highlighting
- `nvim-lspconfig` - LSP support
- `nvim-cmp` - completion engine
- `harpoon` - quick file navigation
- `flash.nvim` - enhanced motions
- `avante.nvim` - AI chat (core to AI workflow)
- `which-key.nvim` - keybinding discovery

**Evaluate These (May be redundant in LazyVim):**
- `nvim-tree.lua` - LazyVim uses neo-tree by default
- `oil.nvim` - overlaps with neo-tree
- `lspkind.nvim` - LazyVim has built-in LSP UI
- `easymotion` - flash.nvim is more modern

**Remove These (Unused based on config comments):**
- Commented-out buffer management code
- Old projection configs

### Current Keybindings to Preserve
From `base.lua`:
- Leader: `<Space>` (LazyVim default, perfect)
- Test runner keybindings: `t<C-n>`, `t<C-f>`, etc.
- Window navigation: `<C-h/j/k/l>`
- Tab navigation: `<M-Left/Right>`

### Current Behaviors to Preserve
- Auto-save on `BufLeave` (except terminal)
- Format on save
- Auto-change to git root directory
- Terminal strategy for test runner

---

## Phase 3: LazyVim Setup (Minimal + AI-First)

### Base LazyVim Installation

Via Nix home-manager:
```nix
programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;

  plugins = with pkgs.vimPlugins; [
    # LazyVim will manage most plugins
    lazy-nvim
  ];

  extraLuaConfig = ''
    -- Bootstrap LazyVim
    require("config.lazy")
  '';
};
```

### LazyVim Config Structure
```
~/.config/nvim/
├── init.lua                 # Bootstrap
├── lua/
│   ├── config/
│   │   ├── lazy.lua        # Lazy.nvim setup
│   │   ├── options.lua     # Vim options
│   │   ├── keymaps.lua     # Custom keymaps
│   │   └── autocmds.lua    # Auto commands
│   └── plugins/
│       ├── ai.lua          # Avante + Codeium
│       ├── editor.lua      # Flash, Harpoon
│       ├── lsp.lua         # LSP configs
│       └── ui.lua          # Theme, which-key
```

### Essential LazyVim Extras to Enable
```lua
-- In lazy.lua
{
  "LazyVim/LazyVim",
  import = "lazyvim.plugins",
  opts = {
    -- AI-oriented extras
    { import = "lazyvim.plugins.extras.coding.codeium" },
    { import = "lazyvim.plugins.extras.ai.avante" },

    -- Essential extras
    { import = "lazyvim.plugins.extras.editor.telescope" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.test.core" },
  },
}
```

---

## Phase 4: AI Tools Integration

### 1. Avante.nvim Configuration

**Migration from current setup:**
```lua
-- lua/plugins/ai.lua
return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "claude",  -- Switch from OpenAI to Claude
      vendors = {
        claude = {
          endpoint = "https://api.anthropic.com/v1/messages",
          model = "claude-sonnet-4-5-20250929",
          api_key_name = "ANTHROPIC_API_KEY",
          max_tokens = 8192,
        },
      },

      -- Preserve your MCP Hub integration
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,

      custom_tools = {
        require("mcphub.extensions.avante").mcp_tool(),
      },

      -- Keep your disabled tools
      disabled_tools = {
        "list_files", "search_files", "read_file",
        "create_file", "rename_file", "delete_file",
        "create_dir", "rename_dir", "delete_dir", "bash",
      },

      -- UI improvements
      windows = {
        ask = {
          focus_on_apply = "theirs",
          floating = true,
          border = "rounded",
        },
      },
    },
  },
}
```

### 2. Codeium Configuration

```lua
-- In lua/plugins/ai.lua
{
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  opts = {
    enable_chat = false,  -- Use Avante for chat
    enable_cmp_source = true,
    enable_inline_completion = true,

    -- Keybindings for inline suggestions
    keybindings = {
      accept = "<Tab>",
      next = "<M-]>",
      prev = "<M-[>",
      clear = "<C-]>",
    },
  },
}
```

### 3. Claude Code CLI Integration

Add custom commands to LazyVim:
```lua
-- In lua/config/autocmds.lua or lua/plugins/ai.lua

vim.api.nvim_create_user_command("ClaudeChat", function()
  vim.cmd("split | terminal claude")
end, {})

vim.api.nvim_create_user_command("ClaudeExplain", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local code = table.concat(lines, "\n")
  -- Open terminal with Claude Code, pass code via temp file
  local tmpfile = vim.fn.tempname()
  vim.fn.writefile(lines, tmpfile)
  vim.cmd("split | terminal claude 'Explain this code:' < " .. tmpfile)
end, {})

-- Keybindings
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeChat<cr>", { desc = "Claude Chat" })
vim.keymap.set("v", "<leader>ae", "<cmd>ClaudeExplain<cr>", { desc = "Claude Explain" })
```

### 4. MCP Hub Integration

Keep your current `mcphub.lua` config:
```lua
-- lua/plugins/mcp.lua
return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("mcphub").setup({
        -- Your existing config
      })
    end,
  },
}
```

---

## Phase 5: AI Workflow Optimizations

### Speed Optimizations

1. **Lazy Loading**
```lua
{
  "yetone/avante.nvim",
  cmd = { "AvanteAsk", "AvanteChat" },  -- Load only when needed
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
  },
}
```

2. **Async Completions**
Codeium runs async by default, but ensure:
```lua
opts = {
  async = true,
  debounce_delay = 50,  -- Fast but not too aggressive
}
```

3. **Cache API Responses**
```lua
-- In Avante config
cache_dir = vim.fn.stdpath("cache") .. "/avante",
```

### Context Optimizations

1. **Auto-gather Project Context**
```lua
-- lua/config/autocmds.lua
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Load project-specific MCP servers
    local project_mcp = vim.fn.getcwd() .. "/.mcp-servers.json"
    if vim.fn.filereadable(project_mcp) == 1 then
      require("mcphub").load_config(project_mcp)
    end
  end,
})
```

2. **Smart File Selection for Context**
```lua
-- Custom command to send relevant files to Claude
vim.api.nvim_create_user_command("ClaudeContext", function()
  -- Gather git-modified files, open buffers, and related files
  local files = {}

  -- Git modified
  local git_files = vim.fn.systemlist("git diff --name-only HEAD")
  vim.list_extend(files, git_files)

  -- Open buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then table.insert(files, name) end
    end
  end

  -- Pass to Avante with context
  -- Implementation here
end, {})
```

3. **LSP-Aware Context**
```lua
-- Include LSP diagnostics in AI prompts
local function get_diagnostics_context()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics > 0 then
    return "Current errors:\n" .. vim.inspect(diagnostics)
  end
  return ""
end
```

### Workflow Optimizations

1. **Quick AI Actions**
```lua
-- lua/config/keymaps.lua

local ai_actions = {
  -- Inline completions (Codeium)
  { "<Tab>", mode = "i", desc = "Accept AI completion" },

  -- Avante chat
  { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask Avante" },
  { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Edit with Avante" },
  { "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Refresh Avante context" },

  -- Claude Code CLI
  { "<leader>ac", "<cmd>ClaudeChat<cr>", desc = "Claude terminal" },
  { "<leader>ax", "<cmd>ClaudeExplain<cr>", mode = "v", desc = "Explain code" },

  -- Context management
  { "<leader>am", "<cmd>McpRefresh<cr>", desc = "Refresh MCP servers" },
  { "<leader>ap", "<cmd>ClaudeContext<cr>", desc = "Gather context for Claude" },
}

for _, mapping in ipairs(ai_actions) do
  vim.keymap.set(mapping.mode or "n", mapping[1], mapping[2], { desc = mapping.desc })
end
```

2. **Auto-suggestions in Comments**
```lua
-- Trigger AI suggestions when typing comments
vim.api.nvim_create_autocmd("InsertCharPre", {
  pattern = "*",
  callback = function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local char = vim.v.char

    -- If typing "TODO:" or "FIXME:", trigger Avante
    if line:match("^%s*#%s*TODO:") or line:match("^%s*//%s*TODO:") then
      vim.defer_fn(function()
        vim.cmd("AvanteAsk")
      end, 500)
    end
  end,
})
```

3. **Git Integration**
```lua
-- Generate commit messages with AI
vim.api.nvim_create_user_command("ClaudeCommit", function()
  local diff = vim.fn.system("git diff --staged")
  if diff ~= "" then
    -- Pass to Claude via Avante or CLI
    vim.cmd("AvanteAsk Generate a commit message for:\n" .. diff)
  end
end, {})
```

---

## Phase 6: Theme Consistency

### Tokyo Night Moon Setup
```lua
-- lua/plugins/ui.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      transparent = true,  -- For Ghostty background blur
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
      },
      on_highlights = function(hl, c)
        -- Enhance AI-related highlights
        hl.CmpItemKindCodeium = { fg = c.teal, bg = c.none }
        hl.AvanteTitle = { fg = c.blue, bold = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },
}
```

---

## Implementation Timeline

### Week 1: Ghostty Migration
- [ ] Add Ghostty to Nix flake
- [ ] Create base config (`~/.config/ghostty/config`)
- [ ] Set up shader directory
- [ ] Download and test CRT shader
- [ ] Create/find blur shader
- [ ] Create custom color grading shader
- [ ] Test performance with real workloads
- [ ] Switch default terminal to Ghostty

### Week 2: Neovim Audit
- [ ] Track actual plugin usage for 1 week
- [ ] Document essential keybindings
- [ ] List must-have behaviors (auto-save, format-on-save, etc.)
- [ ] Export current theme settings
- [ ] Back up current config to git branch

### Week 3: LazyVim Setup
- [ ] Install LazyVim via Nix
- [ ] Configure base LazyVim (options, keymaps)
- [ ] Set up Tokyo Night theme
- [ ] Enable essential LazyVim extras
- [ ] Migrate must-have plugins (harpoon, flash)
- [ ] Test LSP functionality

### Week 4: AI Integration
- [ ] Migrate Avante.nvim config (switch to Claude)
- [ ] Set up Codeium
- [ ] Restore MCP Hub integration
- [ ] Create Claude Code CLI commands
- [ ] Configure AI keybindings
- [ ] Test AI workflows (speed, context, suggestions)

### Week 5: Workflow Optimization
- [ ] Implement auto-context gathering
- [ ] Set up LSP-aware AI prompts
- [ ] Create git integration commands
- [ ] Fine-tune lazy loading
- [ ] Optimize completion debouncing
- [ ] Document final keybindings

### Week 6: Polish & Documentation
- [ ] Remove Kitty from Nix config
- [ ] Remove old nvim config
- [ ] Document new setup in repo README
- [ ] Create cheat sheet for AI keybindings
- [ ] Share config with community (optional)

---

## Rollback Plan

### If Ghostty Issues
- Keep Kitty config in `conf.d/terminal/kitty.conf.backup`
- Quick switch: `export TERMINAL=kitty` in shell config

### If LazyVim Issues
- Old config backed up in git branch `nvim-old-config`
- Restore: `git checkout nvim-old-config -- modules/editor/nvim/`
- Keep both configs: use `NVIM_APPNAME=nvim-old` to run old config

---

## Success Criteria

### Ghostty
- [ ] Terminal startup < 50ms
- [ ] Shaders don't affect input latency
- [ ] Theme matches nvim perfectly
- [ ] All keybindings work

### LazyVim
- [ ] Startup time < 100ms (`:Lazy profile`)
- [ ] All essential plugins working
- [ ] No unused plugins installed
- [ ] LSP performance maintained or improved

### AI Workflow
- [ ] Codeium suggestions appear < 100ms after typing
- [ ] Avante responses < 5s for simple queries
- [ ] MCP context loading works automatically
- [ ] Claude Code CLI accessible via keybindings
- [ ] Context gathering is automatic and accurate

---

## Resources

### Ghostty Shaders
- [CRT shader with chromatic aberration](https://github.com/luiscarlospando/crt-shader-with-chromatic-aberration-glow-scanlines-dot-matrix)
- [Thijs Kok's ghostty-shaders](https://github.com/thijskok/ghostty-shaders)
- [Fun with Ghostty Shaders](https://catskull.net/fun-with-ghostty-shaders.html)
- [Retro CRT guide](https://jeffhottinger.com/blog/2025/02/how-to-configure-ghostty-as-a-retro-crt-on-mac/)

### LazyVim + AI
- [Avante.nvim repo](https://github.com/yetone/avante.nvim)
- [LazyVim Avante discussion](https://github.com/LazyVim/LazyVim/discussions/4402)
- [Codeium setup discussion](https://github.com/LazyVim/LazyVim/discussions/1006)
- [LazyVim documentation](http://www.lazyvim.org/)

---

## Next Steps

1. **Review this plan** - any adjustments needed?
2. **Start Week 1** - Ghostty setup (want me to help implement?)
3. **Track progress** - use TODO.md or create a new tracking file?

What do you think? Want to dive into Phase 1 (Ghostty) right away, or would you like to adjust anything in the plan?
