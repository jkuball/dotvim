local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
	vim.notify("Successfully bootstrapped lazy.nvim!", vim.log.levels.INFO)
end
vim.opt.rtp:prepend(lazypath)

-- Setting both leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Enables 24-bit RGB color in the terminal
vim.opt.termguicolors = true

-- use lazy.nvim to load all plugin specs from lua/plugins/*.lua
--- @type LazyConfig
local opts = {
	install = {
		colorscheme = { "catppuccin", "habamax" }
	},
	change_detection = {
		notify = false
	},
	defaults = {
		lazy = true,
	}
}
require("lazy").setup("plugins", opts)

-- For debugging the loading order of plugins:
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyLoad",
	callback = function(args)
		print("Loaded plugin '" .. args.data .. "'!")
	end,
})
