-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "gruvchad" },
}

--[[ M.options = {
   user = function()
      vim.opt.number = true
   end,
}
 ]]

-- Mappings
M.mappings = require("custom.mappings")

-- Install plugins
M.plugins = "custom.plugins" -- path to table

return M
