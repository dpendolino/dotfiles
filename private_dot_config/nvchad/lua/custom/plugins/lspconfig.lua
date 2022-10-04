function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

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
  local filetypes = nil
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
  if lsp == "terraformls" then
    filetypes = { "terraform", "hcl", "tf" }
  end
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings,
    filetypes = filetypes,
  })
end

vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
