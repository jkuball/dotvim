local common_options = { noremap = true, silent = true }

-- Jump between diagnostics marks
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, common_options)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, common_options)
