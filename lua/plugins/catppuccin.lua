--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/catppuccin/nvim",
	name = "catppuccin",
	version = "^1.6.0",
	lazy = false,
	priority = 9001,
	--- @type CatppuccinOptions
	opts = {
		flavour = "mocha",
	},
	--- @param opts? CatppuccinOptions
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}}

return specs
