-- Consider:
-- https://github.com/ray-x/navigator.lua
-- https://github.com/lukas-reineke/cmp-under-comparator
-- https://github.com/hkupty/iron.nvim -- repl
-- https://github.com/DNLHC/glance.nvim -- A pretty window for previewing, navigating and editing your LSP locations in one place, inspired by vscode's peek preview.
--
-- nvim-ts-autotag
-- ts-comments.nvim

return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    keys = { "<C-g>s", "<C-g>S", "ys", "yss", "yS", "ySS", "S", "gS", "ds", "cs", "cS" },
    opts = {},
  },
  {
    -- magic nvim-surround keymaps
    "roobert/surround-ui.nvim",
    lazy = false,
    keys = {
      { "<leader>ss", desc = "Surround UI" },
    },
    opts = {
      root_key = "ss",
    },
  },
  {
    "johnfrankmorgan/whitespace.nvim",
    config = function()
      require("whitespace-nvim").setup({
        -- configuration options and their defaults

        -- `highlight` configures which highlight is used to display
        -- trailing whitespace
        highlight = "DiffDelete",

        -- `ignored_filetypes` configures which filetypes to ignore when
        -- displaying trailing whitespace
        ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "dashboard", "ministarter" },

        -- `ignore_terminal` configures whether to ignore terminal buffers
        ignore_terminal = true,

        -- `return_cursor` configures if cursor should return to previous
        -- position after trimming whitespace
        return_cursor = true,
      })

      -- remove trailing whitespace with a keybinding
      vim.keymap.set("n", "<Leader>ct", require("whitespace-nvim").trim)
    end,
  },
  {
    "aspeddro/gitui.nvim",
    lazy = false,
  },
}
