local utils = require('heirline.utils')

return {
	condition = function()
		-- TODO: See if there is a way to check if harpoon is loaded,
		-- so the statusline doesn't do it.
		return require("harpoon"):list():length() > 0
	end,
	hl = {
		fg = utils.get_highlight("Constant").fg,
	},
	on_click = {
		name = "heirline_harpoon_ui_toggle",
		callback = function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
	},
	{
		provider = function()
			return "⇀ " .. require("harpoon"):list():length()
		end,
		hl = { bold = true },
	},
}
