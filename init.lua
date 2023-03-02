-- Disable netrw in favor of nvim-tree
-- TODO: Find a place to do this in, so it is more explicit.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("packer_bootstrap").setup()
