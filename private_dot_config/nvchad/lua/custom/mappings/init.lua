-- lua/custom/mappings
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
    ["<C-n>"] = { "<cmd> Telescope <CR>", "Open Telescope" },
    ["<leader>cc"] = { "<cmd> Telescope <CR>", "Open Telescope" },
    ["<leader>o"] = { "<cmd> MarkdownPreview <CR>", "Render Markdown in Browser" }, -- TODO: set mapping on markdown files only
    ["<leader>lf"] = { "<cmd> lua vim.lsp.buf.format() <CR>", "Format Buffer" },
    ["gx"] = { '[[:execute "!open " . shellescape(expand("<cfile>"), 1)<CR>]]', "Open file under cursor" },
    ["<leader>up"] = { "<cmd> PackerUpdate <CR>", "Run PackerUpdate" },
    ["<leader>us"] = { "<cmd> PackerSync <CR>", "Run PackerSync" },
    ["<leader>uc"] = { "<cmd> PackerCompile <CR>", "Run PackerCompile" },
    ["<leader>`"] = { "<cmd> lua require('FTerm').toggle()<CR>", "Toggle FTerm" },
    ["<leader><leader>"] = { "<cmd> lua require('FTerm').toggle()<CR>", "Toggle FTerm" },
  },

  i = {
    -- more keys!
  },

  t = { ["<ESC>"] = { 'termcodes "<C-\\><C-N>"', "escape terminal mode" } },
}

M.xyz = {
  -- stuff
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
