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
}
