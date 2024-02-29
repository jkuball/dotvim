-- TODO: When starting nvim and not touching the mouse or keyboard the hover starts initially once. I don't like that.

--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/soulis-1256/eagle.nvim",
	branch = "main", -- not maintaining releases
	--- @type table
	opts = {},
	event = "LspAttach",
	config = function(_, opts)
		require("eagle").setup(opts)

		if not vim.o.mousemoveevent then
			vim.notify("eagle.nvim does not really work when 'mousemoveevent' is not set", vim.log.levels.WARN)
		end
	end,
}}

return specs
