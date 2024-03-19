--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/rebelot/heirline.nvim",
	version = "^1.0.3",
	event = "UiEnter",
	config = function()
		local dotvim_heirline = require("dotvim.heirline")

		require("heirline").setup({
			statusline = dotvim_heirline.statusline,
			winbar = dotvim_heirline.winbar,
			tabline = dotvim_heirline.tabline,
			statuscolumn = dotvim_heirline.statuscolumn,
			opts = {
				disable_winbar_cb = dotvim_heirline.disable_winbar_cb,
			},
		})
	end,
}}

return specs
