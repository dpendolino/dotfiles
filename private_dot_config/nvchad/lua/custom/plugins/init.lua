-- custom/plugins/init.lua

return {

  ["elkowar/yuck.vim"] = { ft = "yuck" },
  ["NvChad/nvterm"] = {
    config = function()
      pcall("require", "plugins.configs.nvterm")
    end,
  },
  ["goolord/alpha-nvim"] = {
    disable = false,
  },
  ["ellisonleao/glow.nvim"] = {
    config = function()
      cmd = "Glow"
    end,
  },
  -- ["b3nj5m1n/kommentary"] = {}, -- Simple plugins can be specified as strings
  ["ekickx/clipboard-image.nvim"] = {}, -- paste images into neovim
  ["rhysd/git-messenger.vim"] = {},
  ["svermeulen/vimpeccable"] = {}, -- convenient lua functions
  ["JoosepAlviste/nvim-ts-context-commentstring"] = {},
  ["ekalinin/Dockerfile.vim"] = {}, -- Vim syntax file for Docker's Dockerfile and snippets for snipMate.
  ["junegunn/vim-peekaboo"] = {},
  ["nacro90/numb.nvim"] = {}, -- peek go to line
  ["williamboman/nvim-lsp-installer"] = {}, -- Helper installer
  ["dstein64/vim-startuptime"] = {}, -- startup profiler
  ["tpope/vim-surround"] = {}, -- surround ops
  ["editorconfig/editorconfig-vim"] = {},
  ["tpope/vim-repeat"] = {}, -- let '.' work with other commands
  ["windwp/nvim-ts-autotag"] = { -- autoclose and autorename html tags
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  ["dominikduda/vim_current_word"] = {}, -- Highlight current word in buffer after delay}
  ["ntpeters/vim-better-whitespace"] = { -- Deal with trailing whitespace
    config = function()
      vim.cmd("map <leader>s :StripWhitespace<CR>")
    end,
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.null-ls").setup()
    end,
  }, -- formatting
  ["folke/which-key.nvim"] = {
    disable = false,
  },
  ["nathom/filetype.nvim"] = {
    config = function()
      require("custom.plugins.filetype").setup()
    end,
  }, -- A fast and lua alternative to filetype.vim. It is ~175x faster than filetype.vim
  ["luukvbaal/stabilize.nvim"] = {
    config = function()
      require("stabilize").setup()
    end,
  },
  ["hrsh7th/nvim-cmp"] = {
    override_options = {
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
  ["lukas-reineke/cmp-rg"] = {
    after = { "nvim-cmp" },
    requires = { "nvim-cmp" },
  },
  ["lukas-reineke/cmp-under-comparator"] = {
    after = { "nvim-cmp" },
    requires = { "nvim-cmp" },
  },
  -- [ "hrsh7th/cmp-nvim-lsp-document-symbol" ],
  ["ray-x/cmp-treesitter"] = {
    after = { "nvim-cmp" },
    requires = { "nvim-cmp" },
  },
  ["hrsh7th/cmp-emoji"] = {
    after = { "nvim-cmp" },
    requires = { "nvim-cmp" },
  },
  ["hrsh7th/cmp-calc"] = {
    after = { "nvim-cmp" },
    requires = { "nvim-cmp" },
  },
  ["iamcco/markdown-preview.nvim"] = {
    run = ":call mkdp#util#install()",
    ft = "markdown",
  },
  ["mattn/gist-vim"] = { -- native gist support
    requires = { "mattn/webapi-vim" },
    config = function()
      vim.g.gist_detect_filetype = true
    end,
  },
  ["stevearc/dressing.nvim"] = {}, -- UI pretty
  ["numToStr/FTerm.nvim"] = {}, -- floating term
  ["phaazon/hop.nvim"] = {
    branch = "v1", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
  },
  ["tpope/vim-fugitive"] = {}, -- git ops
  ["chip/telescope-software-licenses.nvim"] = { -- easily insert FOSS licenses
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    after = "telescope.nvim",
    config = function()
      require("telescope").load_extension("software-licenses")
    end,
  },
  ["nvim-telescope/telescope-dap.nvim"] = { -- dap
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    after = "telescope.nvim",
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
  ["mfussenegger/nvim-dap"] = { -- debug adapters support
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
      dap.adapters.go = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/vscode-go/dist/debugAdapter.js" },
      }
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          showLog = false,
          program = "${file}",
          dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
        },
      }
    end,
  },
  ["chrisbra/csv.vim"] = { -- way better CSV experience
    ft = "csv",
    config = function()
      vim.g.csv_delim_test = ",;|"
      vim.g.csv_default_delim = ","
    end,
  },
  ["leoluz/nvim-dap-go"] = {},
  ["mfussenegger/nvim-dap-python"] = {
    config = function()
      require("dap-python").setup("python3")
    end,
  },
  ["suketa/nvim-dap-ruby"] = {
    config = function()
      require("dap-ruby").setup()
    end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  },
  ["powerman/vim-plugin-AnsiEsc"] = {}, -- read ansi color escapes
  ["mrjones2014/smart-splits.nvim"] = {
    config = function()
      require("smart-splits").ignored_buftypes = { "NvimTree" }
      require("smart-splits").ignored_filetypes = {
        "nofile",
        "quickfix",
        "prompt",
      }
      -- recommended mappings
      -- resizing splits
      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
      -- moving between splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
    end,
  },
  ["kdheepak/lazygit.nvim"] = {}, -- Git TUI
  ["AckslD/nvim-trevJ.lua"] = {
    config = 'require("trevj").setup()', -- optional call for configurating non-default filetypes etc

    -- uncomment if you want to lazy load
    -- module = 'trevj',

    -- an example for configuring a keybind, can also be done by filetype
    setup = function()
      vim.keymap.set("n", "<leader>j", function()
        require("trevj").format_at_cursor()
      end)
    end,
  },
  ["dhruvasagar/vim-table-mode"] = {}, -- great Markdown table support
  ["fatih/vim-go"] = {
    ft = "go",
  }, -- go support
  ["earthly/earthly.vim"] = {}, -- syntax highlighting for earthly cicd
  ["nvim-treesitter/nvim-treesitter-context"] = {},
  ["nvim-telescope/telescope-file-browser.nvim"] = {
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    after = "telescope.nvim",
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
  ["williamboman/mason.nvim"] = {
    override_options = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",
        -- web dev
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "emmet-ls",
        "json-lsp",
        -- shell
        "shfmt",
        "shellcheck",
        -- python3
        "pyright",
        -- misc
        "clangd",
        "rust-analyzer",
        "gopls",
        "bash-language-server",
        "yaml-language-server",
        "terraform-ls",
        "tflint",
        "dockerfile-language-server",
        "ansible-language-server",
        "solargraph",
        "marksman",
      },
    },
  },
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.plugins.lspconfig")
    end,
  },
  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = {
      ensure_installed = {
        "html",
        "css",
        "python",
        "go",
        "yaml",
      },
    },
  },
  ["kyazdani42/nvim-tree.lua"] = {
    override_options = {
      config = {
        open_on_setup = true,
      },
    },
  },
}
