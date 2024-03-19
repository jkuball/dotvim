--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/ofirgall/open.nvim",
	branch = "master", -- This plugin has no releases
	opts = {},
	keys = {
		{ "gx", function() require("open").open_cword() end },
	},
}}

return specs
