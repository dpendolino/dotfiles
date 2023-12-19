-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
-- copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_no_mappings = true
vim.keymap.set('i', '<S-Right>', 'copilot#Accept("<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_assume_mapped = true
