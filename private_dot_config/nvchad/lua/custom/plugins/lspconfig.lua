local M = {}

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

M.setup_lsp = function(attach, capabilities)
  local lsp_installer = require "nvim-lsp-installer"

  -- nvim-cmp Setup lspconfig.
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Enable the following language servers
  local servers = {
    'clangd',
    'rust_analyzer',
    'pyright',
    'tsserver',
    'gopls',
    'bashls',
    'yamlls',
    'jsonls',
    'html',
    'terraformls',
    'tflint',
    'eslint',
    'sumneko_lua',
    'dockerls',
    'ansiblels',
    'null-ls'
  }

  -- lsp installers
  local lsp_installer_servers = require('nvim-lsp-installer.servers')
  for _, server_name in pairs(servers) do
    local server_available, server = lsp_installer_servers.get_server(server_name)
    if server_available and not server:is_installed() then
      -- Queue the server to be installed.
      server:install()
    end
  end

   lsp_installer.settings {
      ui = {
         icons = {
            server_installed = "﫟" ,
            server_pending = "",
            server_uninstalled = "✗",
         },
      },
   }

   lsp_installer.on_server_ready(function(server)
      local opts = {
         on_attach = attach,
         capabilities = capabilities,
         flags = {
            debounce_text_changes = 150,
         },
         settings = {},
      }

      -- basic example to edit lsp server's options, disabling tsserver's inbuilt formatter
      if server.name == 'tsserver' then
        opts.on_attach = function(client, bufnr)
           client.resolved_capabilities.document_formatting = false
           vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
        end
      end
      if server.name == "sumneko_lua" then
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            },
            runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            workspace = {
              library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
            },
          },
        }
      end

      server:setup(opts)
      vim.cmd [[ do User LspAttachBuffers ]]
      -- Map :Format to vim.lsp.buf.formatting()
      vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
   end)
end

return M
