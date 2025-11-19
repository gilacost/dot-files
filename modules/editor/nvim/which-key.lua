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
}, { prefix = "<leader>" })