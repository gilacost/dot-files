-- Which-key for key binding discovery
require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
})

-- Register key groups for better organization
require("which-key").register({
  h = {
    name = "Harpoon",
    a = "Add file",
    h = "Toggle menu", 
    n = "Next mark",
    p = "Previous mark",
  },
  p = {
    name = "Project",
    f = "Find files in projects",
    s = "Search in projects", 
    b = "Project buffers",
    p = "Project picker",
  },
  f = {
    name = "Find",
    f = "Files in current dir",
    h = "Help tags",
    s = "Symbols",
  },
  s = {
    name = "Search",
    c = "Live grep (git root)",
    s = "Live grep (current dir)",
  },
  t = {
    name = "Tabs",
    t = "New tab + terminal",
    w = "New tab for worktree",
    n = "Next tab",
    p = "Prev tab",
    x = "Close tab",
    ["1"] = "Tab 1", ["2"] = "Tab 2", ["3"] = "Tab 3",
    ["4"] = "Tab 4", ["5"] = "Tab 5", ["6"] = "Tab 6",
    ["7"] = "Tab 7", ["8"] = "Tab 8", ["9"] = "Tab 9",
  },
}, { prefix = "<leader>" })