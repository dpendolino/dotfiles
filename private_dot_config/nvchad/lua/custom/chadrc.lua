-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
  theme = "chadracula",
}

-- Install plugins
local userPlugins = require("custom.plugins") -- path to table

M.plugins = {
  install = userPlugins,
  status = {
    alpha = true,
    colorizer = true,
    cmp = true,
    blankline = true,
  },
  default_plugin_config_replace = {
    nvim_treesitter = {
      ensure_installed = {
        "html",
        "css",
        "python",
        "go",
        "yaml",
      },
    },
    nvim_cmp = {
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
    alpha = "custom.plugin_confs.alpha",
  },
  options = {
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },
  },
}

return M
