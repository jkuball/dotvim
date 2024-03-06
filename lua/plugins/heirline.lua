--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/rebelot/heirline.nvim",
	version = "^1.0.3",
	event = "UiEnter",
	opts = {},
	config = function(_, opts)
		local dotvim_heirline = require("dotvim.heirline")

		require("heirline").setup({
			statusline = dotvim_heirline.statusline,
			winbar = dotvim_heirline.winbar,
			tabline = dotvim_heirline.tabline,
			statuscolumn = dotvim_heirline.statuscolumn,
			opts = opts,
		})
	end,
}}

return specs
