-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require('packer').startup(function(use)
  use {'wbthomason/packer.nvim', opt = true} -- Packer can manage itself as an optional plugin
  use 'b3nj5m1n/kommentary' -- Simple plugins can be specified as strings
  use 'ekickx/clipboard-image.nvim' -- paste images into neovim
  use 'rhysd/git-messenger.vim'
  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-dap-python'
  use 'svermeulen/vimpeccable' -- convenient lua functions
  use 'vim-test/vim-test'
  use 'rcarriga/vim-ultest'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'ekalinin/Dockerfile.vim' -- Vim syntax file for Docker's Dockerfile and snippets for snipMate.
  use 'junegunn/vim-peekaboo'
  use 'nacro90/numb.nvim' -- peek go to line
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua' -- file browser
  -- Add git related info in the signs columns and popups
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} }
  -- UI to select things (files, grep results, open buffers...)
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use 'ludovicchabant/vim-gutentags' -- Automatic tags management

  -- https://github.com/mjlbach/defaults.nvim/blob/master/init.lua
  -- use 'hrsh7th/nvim-compe'           -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use "lukas-reineke/cmp-rg"
  use "lukas-reineke/cmp-under-comparator"
  use "hrsh7th/cmp-nvim-lsp-document-symbol"
  use "ray-x/cmp-treesitter"
  use "hrsh7th/cmp-emoji"
  use "hrsh7th/cmp-calc"

  use 'neovim/nvim-lspconfig'        -- Collection of configurations for built-in LSP client
  use 'nvim-lua/completion-nvim'
  use 'tpope/vim-rhubarb'            -- Fugitive-companion to interact with github
  use 'tpope/vim-fugitive'           -- Git commands in nvim
  use 'elzr/vim-json'                -- JSON highlighting and text objects
  use 'kassio/neoterm'               -- better terminal support
  use 'sayanarijit/xplr.vim'         -- xplr file picker
  use {"ahmedkhalf/lsp-rooter.nvim"} -- Automagically cd to project directory using nvim lsp
  use 'ethanholz/nvim-lastplace'     -- Intelligently reopen files at your last edit position.
  use {"kdav5758/HighStr.nvim"}      -- Highlight visual selection in any given pre-defined color
  use {'tpope/vim-dispatch'}         -- run async commands
  use {'hashivim/vim-terraform'}     -- terraform integration
  use {'github/copilot.vim'}         -- github copilot integration
  use {'chrisbra/Colorizer'}         -- colorize hex codes
  use {'dstein64/vim-startuptime'}   -- startup profiler
  use {'tpope/vim-surround'}
  use {'kristijanhusak/orgmode.nvim', config = function()
        require('orgmode').setup{}
      end
  }
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  use {'luizribeiro/vim-cooklang'}
  use {'ldelossa/calltree.nvim' }

  use {'editorconfig/editorconfig-vim'}
  use {'mg979/vim-visual-multi'}
  use {'bogado/file-line'}
  use {'ryanoasis/vim-devicons'}
  use {'Shougo/neomru.vim'}
  use {'mhinz/vim-startify'}      -- start screen
  use {'tpope/vim-repeat'}        -- let '.' work with other commands
  use {'ynkdir/vim-vimlparser'}
  use {'syngan/vim-vimlint'}
  use {'honza/vim-snippets'}      -- snippets
  use {'SirVer/ultisnips'}
  use {'romainl/vim-cool'}        -- smart highlight
  use {'simnalamburt/vim-mundo'}
  use {'michaeljsmith/vim-indent-object'}
  use {'dominikduda/vim_current_word'}  -- Highlight current word in buffer after delay}
  use {'pechorin/any-jump.nvim'} -- Vim plu}gin for "jump to defitinition" and "find usages}feature through nice popup ui}
  use {'mustache/vim-mustache-handlebars'}
  use {'dag/vim-fish'}
  use {'rust-lang/rust.vim'}
  use {'cespare/vim-toml'}

  -- easymotion replacement
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }


 use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }
-- Or lazy load with `module` option. See further down for info on how to lazy load when using FocusSplit commands
-- Or lazy load this plugin by creating an arbitrary command using the cmd option in packer.nvim
-- use { 'beauwilliams/focus.nvim', cmd = "FocusSplitNicely", module = "focus",
--     config = function()
--         require("focus").setup({hybridnumber = true})
--     end
-- }
require("focus").setup({enable = true, cursorline = true, signcolumn = true, hybridnumber = true})



  use {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup {
        signs = true, -- show icons in the signs column
        -- keywords recognized as todo comments
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        highlight = {
          before = "", -- "fg" or "bg" or empty
          keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
          after = "fg", -- "fg" or "bg" or empty
        },
        -- list of named colors where we try to extract the guifg from the
        -- list of hilight groups or use the hex color if hl not found as a fallback
        colors = {
          error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
          warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
          info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
          hint = { "LspDiagnosticsDefaultHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        -- TODO: figure out
        -- pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      }
    end
  }

  use 'vigoux/LanguageTool.nvim' -- grammar checking
  vim.g["languagetool_server_command"] = 'echo "Server Started"'
  vim.g["languagetool_port"] = '8081'
  -- vim.g["languagetool_server"] = '$HOME/Downloads/LanguageTool-5.5/languagetool-server.jar'

  -- use 'dpelle/vim-LanguageTool'

  -- colorschemes
  use 'pineapplegiant/spaceduck'
  use 'dracula/vim'
  use 'arcticicestudio/nord-vim'
  use 'https://github.com/frankier/neovim-colors-solarized-truecolor-only.git' -- for diffs
  use { "briones-gabriel/darcula-solid.nvim", requires = "rktjmp/lush.nvim" } -- A color-scheme that was heavily inspired by the JetBrains IntelliJ IDEA default theme
  use {'chriskempson/base16-vim'}
  -- end colorschemes

  -- opposite of join line
  use {
    'AckslD/nvim-revJ.lua',
    requires = {'sgur/vim-textobj-parameter'},
  }

  -- autoclose and autorename html tags
  use { 'windwp/nvim-ts-autotag', opt = true }
  require'nvim-treesitter.configs'.setup {
    autotag = {
      enable = true,
    }
  }

  -- status line
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('lualine').setup{
        options = {
          theme = 'nord',
          section_separators = {'', ''},
          component_separators = {'', ''},
          icons_enabled = true,
        },
        sections = {
          lualine_a = { {'mode', upper = true} },
          lualine_b = { {'branch', icon = ''} },
          lualine_c = { {'filename', file_status = true} },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location'  },
        },
        inactive_sections = {
          lualine_a = {  },
          lualine_b = {  },
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {  },
          lualine_z = {   }
        },
        extensions = { 'fzf' }
      }
    end
  }

  -- WhichKey
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
          window = {
            border = "double", -- none, single, double, shadow
          }
      }
    end
  }

    -- vim-sensible
  use 'https://github.com/tpope/vim-sensible'

  -- Line up a certain character in each line
  use 'https://github.com/junegunn/vim-easy-align.git'

  -- A git UI plugin
  use 'https://github.com/tpope/vim-fugitive.git'

  -- a simple, unified, single tabpage, interface that lets you easily review all changed files for any git rev.
  use 'sindrets/diffview.nvim'

  -- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.
  use {
    "folke/lsp-trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

end)
