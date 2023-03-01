-- Enables 24-bit RGB color in the terminal
vim.opt.termguicolors = true

-- Jump between diagnostics marks
local common_map_options = { noremap = true, silent = true }
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, common_map_options)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, common_map_options)
