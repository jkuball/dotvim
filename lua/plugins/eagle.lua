-- TODO: When starting nvim and not touching the mouse or keyboard the hover starts initially once. I don't like that.
-- TODO: Does not work in neovide.

--- @type LazyPluginSpec[]
local specs = { {
	"https://github.com/soulis-1256/eagle.nvim",
	branch = "main", -- not maintaining releases
	--- @type table
	opts = {},
	cmd = "Eagle",
	config = function(_, opts)
		require("eagle").setup(opts)
		vim.api.nvim_create_user_command( "Eagle", function() vim.notify("Start Eagling! 🦅") end, {})
		vim.o.mousemoveevent = true
	end,
} }

return specs
