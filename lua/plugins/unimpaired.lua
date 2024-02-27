--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/tpope/vim-unimpaired",
	version = "^2.1",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		local uwk = require("unimpaired-which-key")
		wk.register(uwk.normal_mode)
		wk.register(uwk.normal_and_visual_mode, { mode = { "n", "v" } })
	end,
	dependencies = {{
		"https://github.com/afreakk/unimpaired-which-key.nvim",
		version = "^0.1",
	}, {
		"https://github.com/folke/which-key.nvim",
	}}
}}

return specs
