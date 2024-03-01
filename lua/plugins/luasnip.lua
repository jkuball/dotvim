-- TODO: Add a skeleton snippet for a nvim/lua/plugin/*.lua file

--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/L3MON4D3/LuaSnip",
	version = "^2.2.0",
	keys = {
		{ "<c-j>", function() require("luasnip").jump(1) end, silent = true, mode = {"i", "s"}, desc = "Jump Forward [luasnip]" },
		{ "<c-k>", function() require("luasnip").jump(-1) end, silent = true, mode = {"i", "s"}, desc = "Jump Backward [luasnip]" },
		-- TODO: maybe revisit c-o later if I have a snippet that has choices available, no idea if this is a good one.
		{ "<c-o>", function()
			local ls = require("luasnip")
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end,
		silent = true, mode = {"i", "s"}, desc = "Change active choice [luasnip]", },
	},
	opts = {},
}}

return specs
