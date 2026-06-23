return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
      "BufReadPre /var/home/dpendolino/Documents/Notes/*.md",
      "BufNewFile /var/home/dpendolino/Documents/Notes/*.md",
      "BufReadPre /var/home/dpendolino/Documents/Dan+Katie/*.md",
      "BufNewFile /var/home/dpendolino/Documents/Dan+Katie/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "/var/home/dpendolino/Documents/Notes",
        },
        {
          name = "dan-katie",
          path = "/var/home/dpendolino/Documents/Dan+Katie",
        },
      },
      completion = {
        nvim_cmp = true, -- registers as cmp source; works through blink.compat
        min_chars = 2,
      },
      picker = {
        name = "telescope.nvim",
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      ui = {
        enable = true,
      },
    },
  },

  -- register obsidian as a blink.compat source
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        compat = {
          "obsidian",
          "obsidian_new",
          "obsidian_tags",
        },
      },
    },
  },
}
