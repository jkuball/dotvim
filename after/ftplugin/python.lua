local common_map_options = { noremap = true, silent = true }
vim.keymap.set("n", "<localleader>r", "<cmd>Dispatch python %<cr>", common_map_options)
