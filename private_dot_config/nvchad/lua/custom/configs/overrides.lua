local M = {}

M.treesitter = {
  ensure_installed = {
    "c",
    "css",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "tsx",
    "typescript",
    "vim",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    "actionlint",
    "bash-language-server",
    "beautysh",
    "clang-format",
    "clangd",
    "css-lsp",
    "deno",
    "dockerfile-language-server",
    "editorconfig-checker",
    "emmet-ls",
    "gopls",
    "html-lsp",
    "json-lsp",
    "lua-language-server",
    "marksman",
    "prettier",
    "prettierd",
    "pyright",
    "rust-analyzer",
    "shellcheck",
    "shellharden",
    "shfmt",
    "solargraph",
    "stylua",
    "terraform-ls",
    "tflint",
    "typescript-language-server",
    "vale",
    "yaml-language-server",
    "yamllint",
  },
  -- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
