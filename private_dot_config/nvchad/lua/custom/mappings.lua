---@type MappingsTable
local M = {}

-- add this table only when you want to disable default keys
--[[ M.disabled = {
  n = {
    ["<leader>h"] = "",
    ["<C-s>"] = "",
  },
}
 ]]

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-n>"] = { "<cmd> Telescope <CR>", "Open Telescope" },
    ["<leader>o"] = { "<cmd> MarkdownPreview <CR>", "Render Markdown in Browser" }, -- TODO: set mapping on markdown files only
    ["gx"] = { '<cmd> execute "!open " . shellescape(expand("<cfile>"), 1)<CR>', "Open file under cursor" },
    ["<leader>up"] = { "<cmd> PackerUpdate <CR>", "Run PackerUpdate" },
    ["<leader>us"] = { "<cmd> PackerSync <CR>", "Run PackerSync" },
    ["<leader>uc"] = { "<cmd> PackerCompile <CR>", "Run PackerCompile" },
  },

  i = {
    -- more keys!
  },

  -- t = { ["<ESC>"] = { 'termcodes "<C-\\><C-N>"', "escape terminal mode" } },
  t = { ["<ESC>"] = { "<C-\\><C-n>", "escape terminal mode" } },
}

M.git = {
  n = {
    ["<leader>gbf"] = { "<cmd> Git blame <CR>", "Git blame entire file" },
    ["<leader>gbl"] = { "<cmd> Gitsigns blame_line <CR>", "Git blame line" },
    ["<leader>gd"] = { "<cmd> Gitsigns diffthis <CR>", "Gitsigns diffthis" },
    ["<leader>gp"] = { "<cmd> Git push <CR>", "Git push" },
    ["<leader>gaf"] = { "<cmd> Git add % <CR>", "Git add current file" },
    ["<leader>gl"] = { "<cmd> LazyGitCurrentFile <CR>", "LazyGitCurrentFile" },
  },
}

M.lsp = {
  n = {
    ["<leader>lf"] = { "<cmd> lua vim.lsp.buf.format() <CR>", "Format Buffer" },
  },
}

M.hop = {
  n = {
    ["<leader>hp"] = { "<cmd> HopPattern <CR>", "HopPattern" },
  },
}

M.telescope = {
  n = {
    ["<leader>cc"] = { "<cmd> Telescope builtin include_extensions=true<CR>", "Open Telescope" },
  },
}

M.terminal = {
  n = {
    ["<leader>`"] = { "<cmd> lua require('nvterm.terminal').toggle 'float' <CR>", "Toggle Floating Terminal" },
    ["<leader><leader>"] = { "<cmd> lua require('nvterm.terminal').toggle 'float' <CR>", "Toggle Floating Terminal" },
    ["<leader>tf"] = { "<cmd> lua require('nvterm.terminal').toggle 'float' <CR>", "Toggle Floating Terminal" },
    ["<leader>th"] = { "<cmd> lua require('nvterm.terminal').toggle 'horizontal' <CR>", "Horizontal Terminal" },
    ["<leader>tv"] = { "<cmd> lua require('nvterm.terminal').toggle 'vertical' <CR>", "Vertical Terminal" },
  },
}

M.yaml = {
  n = {
    ["<leader>ys"] = {
      function()
        local schema = require("yaml-companion").get_buf_schema(0)
        if schema then
          vim.notify(string.format("Schema: %s", schema.result[1].name))
        else
          vim.notify("Schema not detected!")
        end
      end,
      desc = "Show the detected YAML Schema",
    },
    ["<leader>yS"] = { "<cmd>Telescope yaml_schema<cr>", desc = "Set YAML Schem" },
  },
}
return M

--[[ map("n", "<leader>dct", '<cmd>lua require"dap".continue()<CR>')
map("n", "<leader>dsv", '<cmd>lua require"dap".step_over()<CR>')
map("n", "<leader>dsi", '<cmd>lua require"dap".step_into()<CR>')
map("n", "<leader>dso", '<cmd>lua require"dap".step_out()<CR>')
map("n", "<leader>dtb", '<cmd>lua require"dap".toggle_breakpoint()<CR>')

map("n", "<leader>dsc", '<cmd>lua require"dap.ui.variables".scopes()<CR>')
map("n", "<leader>dhh", '<cmd>lua require"dap.ui.variables".hover()<CR>')
map("v", "<leader>dhv", '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')

map("n", "<leader>duh", '<cmd>lua require"dap.ui.widgets".hover()<CR>')
map("n", "<leader>duf", "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")

map("n", "<leader>dsbr", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
map("n", "<leader>dsbm", '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
map("n", "<leader>dro", '<cmd>lua require"dap".repl.open()<CR>')
map("n", "<leader>drl", '<cmd>lua require"dap".repl.run_last()<CR>')

-- telescope-dap
map("n", "<leader>dcc", '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
map("n", "<leader>dco", '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>')
map("n", "<leader>dlb", '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>')
map("n", "<leader>dv", '<cmd>lua require"telescope".extensions.dap.variables{}<CR>')
map("n", "<leader>df", '<cmd>lua require"telescope".extensions.dap.frames{}<CR>')
 ]]
