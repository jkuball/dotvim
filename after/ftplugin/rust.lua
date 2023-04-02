local common_map_options = { noremap = true, silent = true }
vim.keymap.set("n", "<localleader>r", "<cmd>Dispatch cargo run<cr>", common_map_options)
