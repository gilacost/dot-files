# AI-First Workflow System

**Goal:** Work seamlessly with Claude Code with zero file conflicts and maximum speed.

---

## The Problem

When you have files open in Neovim and Claude edits them:
- File conflicts on save
- Manual context switching (save, exit, run claude, reopen)
- Lost flow state
- Slow iteration

---

## The Solution: Session-Based Workflow

### Core Concept

**Two modes:**
1. **Edit Mode** - You're in Neovim, making changes
2. **AI Mode** - Claude is working, Neovim is paused/monitoring

**Fast handoff between modes with one command.**

---

## Workspace Organization

### Directory Structure

```
your-project/
├── .ai/                    # AI scratch space (gitignored)
│   ├── context.md          # Current task context
│   ├── notes.md            # AI session notes
│   └── todos.md            # AI-generated todos
├── src/                    # Your code (both edit)
├── tests/                  # Tests (both edit)
└── docs/                   # Documentation (both edit)
```

### File Ownership Rules

**You own (edit mode only):**
- Active work-in-progress files
- Your daily notes
- Personal scratch files in `.ai/`

**Claude owns (AI mode only):**
- Files you explicitly ask Claude to edit
- Generated code/tests/docs
- Refactoring across multiple files

**Both can edit (with coordination):**
- Codebase files via handoff protocol
- Shared documentation

---

## Neovim Commands

### Install These in Your Config

```lua
-- In lua/plugins/claude-workflow.lua

-- Quick handoff to Claude
vim.api.nvim_create_user_command("ClaudeMode", function(opts)
  -- Save all buffers
  vim.cmd("wall")

  -- Create context file for Claude
  local context_file = vim.fn.getcwd() .. "/.ai/context.md"
  local context = {
    "# Task for Claude",
    "",
    "## What I need:",
    opts.args or "Help with current task",
    "",
    "## Files in focus:",
  }

  -- List open buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        table.insert(context, "- " .. name)
      end
    end
  end

  -- Write context
  vim.fn.mkdir(vim.fn.getcwd() .. "/.ai", "p")
  vim.fn.writefile(context, context_file)

  -- Git safety commit
  vim.fn.system("git add -A && git commit -m 'WIP: before Claude session' --no-verify 2>/dev/null")

  -- Launch Claude in terminal split
  vim.cmd("split | terminal claude < " .. context_file)

  -- Set up auto-reload when terminal closes
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      vim.cmd("checktime")
      vim.notify("Claude session ended. Files reloaded.", vim.log.levels.INFO)

      -- Show diff of changes
      vim.defer_fn(function()
        vim.cmd("split | terminal git diff HEAD~1 --color=always | less -R")
      end, 500)
    end,
    once = true,
  })
end, { nargs = "?" })

-- Quick Claude commands without full handoff
vim.api.nvim_create_user_command("ClaudeQuick", function(opts)
  local prompt = opts.args
  if not prompt or prompt == "" then
    vim.notify("Usage: ClaudeQuick <prompt>", vim.log.levels.ERROR)
    return
  end

  -- Get current file
  local filepath = vim.fn.expand("%:p")

  -- Save current file
  vim.cmd("write")

  -- Run Claude in background, show output in split
  vim.cmd("split | terminal claude '" .. prompt .. "' " .. filepath)
end, { nargs = 1 })

-- Resume editing after Claude session (auto-happens, but explicit command too)
vim.api.nvim_create_user_command("ResumeEdit", function()
  vim.cmd("checktime")
  vim.notify("Reloaded all buffers", vim.log.levels.INFO)
end, {})

-- Keybindings
vim.keymap.set("n", "<leader>am", ":ClaudeMode ", { desc = "Enter AI Mode with task" })
vim.keymap.set("n", "<leader>aq", ":ClaudeQuick ", { desc = "Quick Claude command" })
vim.keymap.set("n", "<leader>ar", "<cmd>ResumeEdit<cr>", { desc = "Resume edit mode" })
```

---

## Shell Workflow Functions

### Add to `functions.sh`

```bash
#####################
# AI Pair Workflow  #
#####################

# Quick AI session (save everything, run Claude, reopen)
function ai() {
  # Check if in git repo
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # Safety commit
  echo "Creating safety commit..."
  git add -A
  git commit -m "WIP: before AI session [$(date +%H:%M)]" --no-verify 2>/dev/null || echo "No changes to commit"

  # Run Claude
  if [ -z "$1" ]; then
    claude
  else
    claude "$@"
  fi

  # Show what changed
  echo ""
  echo "=== Changes from AI session ==="
  git diff HEAD~1 --stat
  echo ""
  echo "Review with: git diff HEAD~1"
  echo "Undo with: git reset HEAD~1"
}

# AI session with specific files as context
function aif() {
  if [ -z "$1" ]; then
    echo "Usage: aif <files...> -- <prompt>"
    echo "Example: aif src/app.js src/utils.js -- 'refactor to use async/await'"
    return 1
  fi

  # Parse files and prompt
  local files=()
  local prompt=""
  local found_separator=false

  for arg in "$@"; do
    if [ "$arg" = "--" ]; then
      found_separator=true
    elif [ "$found_separator" = true ]; then
      prompt="$prompt $arg"
    else
      files+=("$arg")
    fi
  done

  if [ ${#files[@]} -eq 0 ]; then
    echo "Error: No files specified"
    return 1
  fi

  # Safety commit
  git add -A
  git commit -m "WIP: before AI session on ${files[*]}" --no-verify 2>/dev/null

  # Run Claude with files
  claude "$prompt" "${files[@]}"

  # Show changes
  git diff HEAD~1 --stat
}

# Check if currently in AI session (for prompt display)
function in_ai_session() {
  # Check if there's a recent WIP commit
  local last_commit=$(git log -1 --format=%s 2>/dev/null)
  if [[ "$last_commit" =~ ^WIP:.*AI\ session ]]; then
    echo " [AI]"
  fi
}

# Undo last AI session
function ai-undo() {
  local last_commit=$(git log -1 --format=%s 2>/dev/null)
  if [[ "$last_commit" =~ ^WIP:.*AI\ session ]]; then
    echo "Undoing AI session: $last_commit"
    git reset HEAD~1
    echo "✓ AI session undone"
  else
    echo "No AI session to undo (last commit wasn't a WIP AI session)"
  fi
}

# Accept AI changes (cleanup commit message)
function ai-accept() {
  local last_commit=$(git log -1 --format=%s 2>/dev/null)
  if [[ "$last_commit" =~ ^WIP:.*AI\ session ]]; then
    echo "What did the AI do? (commit message):"
    read -r message
    git commit --amend -m "$message" --no-verify
    echo "✓ AI changes accepted with message: $message"
  else
    echo "No AI session to accept"
  fi
}

# AI session status
function ai-status() {
  local last_commit=$(git log -1 --format=%s 2>/dev/null)

  if [[ "$last_commit" =~ ^WIP:.*AI\ session ]]; then
    echo "📌 Currently in AI session"
    echo ""
    echo "Last commit: $last_commit"
    echo ""
    echo "Changes:"
    git diff HEAD~1 --stat
    echo ""
    echo "Commands:"
    echo "  ai-accept  - Accept changes and write proper commit message"
    echo "  ai-undo    - Undo AI changes completely"
    echo "  git diff HEAD~1  - Review all changes"
  else
    echo "✓ Not in AI session"
  fi
}
```

---

## Git Integration

### Auto-commits for Safety

Every AI session automatically creates a `WIP: before AI session` commit. This gives you:

1. **Instant undo** - `git reset HEAD~1` to undo everything Claude did
2. **Clear history** - See exactly what Claude changed
3. **No fear** - Experiment freely, easy rollback

### Gitignore for AI Workspace

Add to `.gitignore`:
```
# AI workspace (scratch notes, not committed)
.ai/context.md
.ai/notes.md
.ai/todos.md

# But keep templates
!.ai/README.md
```

---

## Full Workflow Examples

### Example 1: Refactor a Component

**You (in Neovim):**
```
:ClaudeMode Refactor UserProfile to use hooks instead of class components
```

**What happens:**
1. All buffers saved
2. Git safety commit created
3. Context file created with your open files
4. Claude terminal opens in split
5. You see Claude working in real-time
6. When done, files auto-reload
7. Git diff shows what changed

**You review:**
```
git diff HEAD~1
```

**If good:**
```bash
ai-accept
# Enter: "refactor: convert UserProfile to hooks"
```

**If bad:**
```bash
ai-undo
```

---

### Example 2: Quick Fix (No Neovim exit)

**You (in Neovim):**
```
:ClaudeQuick Fix the type errors in this file
```

**What happens:**
1. Current file saved
2. Claude runs on just that file
3. Output shows in terminal split
4. File auto-reloads when done
5. You're still in Neovim

---

### Example 3: Shell-Based AI Session

**You (in terminal):**
```bash
# Simple session
ai "add tests for the auth module"

# With specific files
aif src/auth.js src/user.js -- "add error handling"

# Check status
ai-status

# Accept or undo
ai-accept
# or
ai-undo
```

---

### Example 4: Working on Multiple Files

**You (in Neovim):**
1. Open 5 related files in buffers
2. `:ClaudeMode Add logging to all these files`
3. Claude sees all open files, edits them
4. Files auto-reload
5. You review in Neovim (each buffer updated)

---

## Speed Optimizations

### 1. Reduce Context Switching

**Before:** `Esc :wqa <Enter> claude "..." <Enter> nvim <Enter>`
**After:** `Esc <leader>am "..." <Enter>`

Saved: ~5 seconds per AI session

### 2. No Manual Git Commits

**Before:** `git add . && git commit && claude && git commit`
**After:** `ai "..."`  (auto-commits)

Saved: ~10 seconds per session

### 3. Instant Rollback

**Before:** Manually undo changes across multiple files
**After:** `ai-undo` (instant)

Saved: 30-60 seconds when needed

### 4. Parallel Work

**Terminal 1:** Claude working on refactor
**Terminal 2 (Neovim):** You're already looking at the diff

No waiting.

---

## Keyboard Shortcuts Summary

**In Neovim:**
- `<leader>am` - Full AI mode handoff
- `<leader>aq` - Quick AI command on current file
- `<leader>ar` - Reload files after external AI session

**In Terminal:**
- `ai "prompt"` - Quick AI session with auto-commit
- `aif file1 file2 -- "prompt"` - AI session on specific files
- `ai-status` - Check if in AI session
- `ai-accept` - Accept AI changes, write proper commit
- `ai-undo` - Undo entire AI session

**Existing (from before):**
- `c "prompt"` - Claude on current directory
- `cg "prompt"` - Claude with git diff
- `gcai` - Generate commit message

---

## When to Use Each

| Scenario | Command | Why |
|----------|---------|-----|
| Refactor across multiple files | `:ClaudeMode <task>` | Full context, all buffers |
| Fix current file quickly | `:ClaudeQuick <task>` | Fast, no mode switch |
| Terminal-based work | `ai "<task>"` | When not in Neovim |
| Specific files only | `aif file1 file2 -- <task>` | Targeted changes |
| Commit with AI message | `gcai` | Git workflow |
| Explain something | `cexp <file>` | Quick help |

---

## Daily Workflow Pattern

**Morning:**
1. Open project in Neovim
2. Check `ai-status` (clean slate)
3. Start coding

**During coding (iterative):**
1. Code → stuck on something
2. `<leader>am "help with X"`
3. Claude works → files reload
4. Review changes → `ai-accept` or `ai-undo`
5. Keep coding

**End of day:**
1. `ai-status` to check for uncommitted AI work
2. `ai-accept` any good changes
3. Regular commit for your own work

**Total time saved:** ~30-60 minutes per day vs manual workflow

---

## Advanced: Neovim Terminal Integration

For the ultimate flow, you can stay in Neovim and watch Claude work:

```lua
-- Add to your Neovim config
-- Opens Claude in vertical split, auto-closes when done
vim.keymap.set("n", "<leader>av", function()
  vim.cmd("wall")  -- Save all
  local prompt = vim.fn.input("Claude task: ")
  if prompt ~= "" then
    vim.cmd("vsplit | terminal claude '" .. prompt .. "'")
    vim.cmd("startinsert")
  end
end, { desc = "Claude in vsplit" })
```

Now you can watch Claude work in a split pane while staying in Neovim.

---

## Next Steps

1. **Implement Neovim commands** (copy lua code to config)
2. **Add shell functions** (copy bash code to functions.sh)
3. **Test with small task** (`ai "add a comment to this file"`)
4. **Build muscle memory** (use `ai` instead of `claude` for a week)
5. **Iterate** (adjust keybindings to your preference)

Want me to help implement these right now?
