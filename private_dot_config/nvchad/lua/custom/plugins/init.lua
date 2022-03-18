return {
  { "elkowar/yuck.vim", ft = "yuck" },
  { "ellisonleao/glow.nvim", cmd = "Glow" },
  { "b3nj5m1n/kommentary" }, -- Simple plugins can be specified as strings
  { "ekickx/clipboard-image.nvim" }, -- paste images into neovim
  { "rhysd/git-messenger.vim" },
  { "svermeulen/vimpeccable" }, -- convenient lua functions
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "ekalinin/Dockerfile.vim" }, -- Vim syntax file for Docker's Dockerfile and snippets for snipMate.
  { "junegunn/vim-peekaboo" },
  { "nacro90/numb.nvim" }, -- peek go to line
  { "williamboman/nvim-lsp-installer" }, -- Helper installer
  { "dstein64/vim-startuptime" }, -- startup profiler
  { "tpope/vim-surround" }, -- surround ops
  { "editorconfig/editorconfig-vim" },
  { "tpope/vim-repeat" }, -- let '.' work with other commands
  {
    "windwp/nvim-ts-autotag", -- autoclose and autorename html tags
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  { "dominikduda/vim_current_word" }, -- Highlight current word in buffer after delay}
  {
    "ntpeters/vim-better-whitespace", -- Deal with trailing whitespace
    config = function()
      vim.cmd("map <leader>s :StripWhitespace<CR>")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugin_confs.null-ls").setup()
    end,
  }, -- formatting
  {
    "folke/which-key.nvim",
    config = function()
      require("custom.plugin_confs.which-key").setup()
    end,
  },
  {
    "nathom/filetype.nvim",
    config = function()
      require("custom.plugin_confs.filetype").setup()
    end,
  }, -- A fast and lua alternative to filetype.vim. It is ~175x faster than filetype.vim
  {
    "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup()
    end,
  },
  { "lukas-reineke/cmp-rg" },
  { "lukas-reineke/cmp-under-comparator" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "ray-x/cmp-treesitter" },
  { "hrsh7th/cmp-emoji" },
  { "hrsh7th/cmp-calc" },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "iamcco/markdown-preview.nvim",
    run = ":call mkdp#util#install()",
    ft = "markdown",
  },
  -- { "nathanaelkane/vim-indent-guides" }, -- Highlight indent levels
  {
    "mattn/gist-vim", -- native gist support
    requires = { "mattn/webapi-vim" },
    config = function()
      vim.g.gist_detect_filetype = true
    end,
  },
  { "stevearc/dressing.nvim" }, -- UI pretty
  { "numToStr/FTerm.nvim" }, -- floating term
  {
    "phaazon/hop.nvim",
    branch = "v1", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
  },
  { "tpope/vim-fugitive" }, -- git ops
  {
    "nvim-neorg/neorg",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.gtd.base"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              -- Configuration here
              workspace = "home",
            },
          },
          ["core.norg.journal"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              -- Configuration here
            },
          },
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                work = "/home/dpendolino/notes/work",
                home = "/home/dpendolino/notes/home",
              },
              autochdir = true, -- Automatically change the directory to the current workspace's root every time
              index = "index.norg", -- The name of the main (root) .norg file
            },
          },
          ["core.norg.concealer"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              -- Configuration here
            },
          },
          ["core.norg.qol.toc"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              -- Configuration here
            },
          },
          ["core.norg.completion"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              -- Configuration here
            },
          },
        },
      })
    end,
    requires = "nvim-lua/plenary.nvim",
  },
  {
    "chip/telescope-software-licenses.nvim", -- easily insert FOSS licenses
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    after = "telescope.nvim",
    config = function()
      require("telescope").load_extension("software-licenses")
    end,
  },
  {
    "nvim-telescope/telescope-symbols.nvim", -- easily insert FOSS licenses
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    after = "telescope.nvim",
    config = function()
      require("telescope.builtin").symbols({ sources = { "emoji", "kaomoji", "gitmoji" } })
    end,
  },
  {
    "mfussenegger/nvim-dap", -- debug adapters support
    config = function()
      local dap = require("dap")
      dap.adapters.ruby = {
        type = "executable",
        command = "bundle",
        args = { "exec", "readapt", "stdio" },
      }
      dap.configurations.ruby = {
        {
          type = "ruby",
          request = "launch",
          name = "Rails",
          program = "bundle",
          programArgs = { "exec", "rails", "s" },
          useBundler = true,
        },
      }
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
}
