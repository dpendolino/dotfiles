local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {

  b.formatting.prettierd.with({ filetypes = { "html", "markdown", "css", "yaml" } }),
  b.formatting.deno_fmt,

  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

  -- Python
  b.formatting.autopep8,

  -- Go
  b.diagnostics.golangci_lint,
  b.formatting.gofmt,

  -- Ruby
  b.diagnostics.rubocop,

  -- Yaml
  b.diagnostics.yamllint,

  -- Vale
  b.diagnostics.vale.with({ filetypes = { "md", "markdown", "tex", "asciidoc" } }),
}

local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(clients)
      -- filter out clients that you don't want to use
      return vim.tbl_filter(function(client)
        return client.name ~= "tsserver"
      end, clients)
    end,
    bufnr = bufnr,
  })
end

M.setup = function()
  null_ls.setup({
    debug = true,
    sources = sources,

    -- format on save
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            lsp_formatting(bufnr)
          end,
        })
      end
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })
    end,
  })
end

return M
