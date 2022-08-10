-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
   theme = "chadracula",
   theme_toggle = {"chadracula", "gruvchad"}
}

--[[ M.options = {
   user = function()
      vim.opt.number = true
   end,
}
 ]]

-- helper function copied from alpha config
local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 36,
    align_shortcut = "right",
    hl = "AlphaButtons",
  }

  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

-- Install plugins
local userPlugins = require "custom.plugins" -- path to table
M.plugins = {
  user = userPlugins,
  status = {
    alpha = true,
    colorizer = true,
    cmp = true,
    blankline = true,
  },
  options = {
    packer = {
      snapshot = "stable_chad",
    },
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },
  },
  override = {
    ["folke/which-key.nvim"] = { disable = false },
    ["nvim-treesitter/nvim-treesitter"] = {
      ensure_installed = {
        "html",
        "css",
        "python",
        "go",
        "yaml",
      },
    },
    ["goolord/alpha-nvim"] = {
      buttons = {
        type = "group",
        val = {
          button("SPC f f", "  Find File  ", ":Telescope find_files<CR>"),
          button("SPC f b", "🗎  File Browser", ":Telescope file_browser<CR>"),
          button("SPC f o", "  Recent File  ", ":Telescope oldfiles<CR>"),
          button("SPC f w", "  Find Word  ", ":Telescope live_grep<CR>"),
          button("SPC b m", "  Bookmarks  ", ":Telescope marks<CR>"),
          button("SPC t h", "  Themes  ", ":Telescope themes<CR>"),
          button("SPC e s", "  Settings", ":e $MYVIMRC | :cd %:p:h <CR>"),
          button("SPC e e", "🗎  New", ":enew <CR>"),
        },
        opts = {
          spacing = 1,
        },
      },
    },
    ["hrsh7th/nvim-cmp"] = {
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "calc" },
        { name = "rg" },
        { name = "path" },
        { name = "nvim_lsp_document_symbol" },
      },
    },
  },
}

return M
