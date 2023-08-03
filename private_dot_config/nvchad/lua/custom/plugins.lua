local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "tpope/vim-surround",
    lazy = false,
  },
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "MaximilianLloyd/ascii.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
  },
  { -- native gist support
    "mattn/gist-vim",
    requires = { "mattn/webapi-vim" },
    config = function()
      vim.g.gist_detect_filetype = true
    end,
  },
  {
    "dstein64/vim-startuptime",
    lazy = true,
  }, -- startup profiler
  {
    "editorconfig/editorconfig-vim",
    lazy = false,
  },
  {
    "tpope/vim-repeat",
    lazy = false,
  }, -- let '.' work with other commands
  {
    "ntpeters/vim-better-whitespace", -- Deal with trailing whitespace
    config = function()
      vim.cmd("map <leader>s :StripWhitespace<CR>")
    end,
  },
  {
    "chrisbra/csv.vim", -- way better CSV experience
    ft = "csv",
    config = function()
      vim.g.csv_delim_test = ",;|"
      vim.g.csv_default_delim = ","
    end,
  },
  {
    "powerman/vim-plugin-AnsiEsc", -- read ansi color escapes
  },
  {
    "dhruvasagar/vim-table-mode", -- great Markdown table support
    ft = "markdown",
  },
  {
    "farmergreg/vim-lastplace", -- restore cursor position with smarts
    lazy = false,
  }

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
