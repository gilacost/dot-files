-- AI workflow tab management
-- Each tab represents a worktree + Claude terminal session

-- Cache branch names to avoid repeated git calls on every tabline redraw
local _branch_cache = {}

local function git_branch(dir)
  if not dir or dir == "" then return nil end
  if _branch_cache[dir] ~= nil then return _branch_cache[dir] end

  local result = vim.fn.system(
    "git -C " .. vim.fn.shellescape(dir) .. " rev-parse --abbrev-ref HEAD 2>/dev/null"
  ):gsub("%s+$", "")

  local name = (result == "" or result:match("^fatal")) and false or result
  _branch_cache[dir] = name
  return name or nil
end

-- Refresh cache when switching tabs (branch may have changed)
vim.api.nvim_create_autocmd("TabEnter", {
  group = vim.api.nvim_create_augroup("TabsBranchCache", { clear = true }),
  callback = function() _branch_cache = {} end,
})

local function tab_label(tp)
  local tabnum = vim.api.nvim_tabpage_get_number(tp)

  -- 1. Try tab-local CWD (set via :tcd)
  local tcd = vim.fn.getcwd(-1, tabnum)
  local branch = git_branch(tcd)
  if branch then return branch end

  -- 2. Scan windows for a buffer with a recognisable path
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tp)) do
    local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    local dir
    if name:match("^term://") then
      dir = name:match("^term://(.-)//")  -- term://~/path//pid:cmd
    elseif name ~= "" then
      dir = vim.fn.fnamemodify(name, ":h")
    end
    if dir then
      branch = git_branch(dir)
      if branch then return branch end
    end
  end

  -- 3. Fall back to directory basename
  return vim.fn.fnamemodify(tcd, ":t")
end

-- Tabline: "1│main  2│feat/x  3│fix/y"
_G.AITabLine = function()
  local s = ""
  for i, tp in ipairs(vim.api.nvim_list_tabpages()) do
    local is_cur = tp == vim.api.nvim_get_current_tabpage()
    s = s .. (is_cur and "%#TabLineSel#" or "%#TabLine#")
    s = s .. "  " .. i .. "│" .. tab_label(tp) .. "  "
  end
  return s .. "%#TabLineFill#"
end

vim.o.tabline = "%!v:lua.AITabLine()"
vim.o.showtabline = 2  -- always show tabline

-- Jump to tab N
for i = 1, 9 do
  vim.keymap.set("n", "<leader>t" .. i,
    function() vim.cmd(i .. "tabnext") end,
    { desc = "Tab " .. i })
end

vim.keymap.set("n", "<leader>tn", ":tabnext<CR>",  { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", ":tabprev<CR>",  { desc = "Prev tab" })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>:terminal<CR>", { desc = "New tab + terminal" })

-- Open a worktree in a new tab with a terminal ready
vim.keymap.set("n", "<leader>tw", function()
  local out = vim.fn.system("git worktree list --porcelain 2>/dev/null")
  if vim.v.shell_error ~= 0 or out == "" then
    vim.notify("No git worktrees found", vim.log.levels.WARN)
    return
  end

  local paths = {}
  for path in out:gmatch("worktree (%S+)") do
    table.insert(paths, path)
  end

  vim.ui.select(paths, {
    prompt = "Open worktree in new tab:",
    format_item = function(p)
      local b = vim.fn.system(
        "git -C " .. vim.fn.shellescape(p) .. " rev-parse --abbrev-ref HEAD 2>/dev/null"
      ):gsub("%s+$", "")
      return (b ~= "" and b or "?") .. "  (" .. p .. ")"
    end,
  }, function(choice)
    if not choice then return end
    vim.cmd("tabnew")
    vim.cmd("tcd " .. vim.fn.fnameescape(choice))
    vim.cmd("terminal")
  end)
end, { desc = "New tab for worktree" })
