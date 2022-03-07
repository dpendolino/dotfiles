local whichkey = require "which-key"

local M = {}

M.setup = function()
  whichkey.setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    window = {
      border = "double", -- none, single, double, shadow
    }
  }
end

return M
