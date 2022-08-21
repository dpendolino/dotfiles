-- custom.plugins.lspconfig
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
-- local servers = { "html", "cssls", "clangd", "pyright"}

local servers = {
  "clangd",
  "rust_analyzer",
  "pyright",
  "tsserver",
  "gopls",
  "bashls",
  "yamlls",
  "jsonls",
  "html",
  "terraformls",
  "tflint",
  "eslint",
  "sumneko_lua",
  "dockerls",
  "ansiblels",
  "solargraph",
  "marksman",
}

for _, lsp in ipairs(servers) do
  if lsp == "sumneko_lua" then
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
      },
    }
  end
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings,
  })
end

vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
