--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/numToStr/Comment.nvim",
	version = "^0.8.0",
	opts = {},
	keys = {
		{ "gc", "Line Comment Motion", mode = {"n", "v"} },
		{ "gb", "Block Comment Motion", mode = {"n", "v"} },
	}
}}

return specs
