--- @class NeoTreeConfig: table
--- @see nvim-help

--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
	version = "^3.17",
	cmd = "Neotree",
	keys = {
		{ "_", "<cmd>:Neotree<cr>", desc = "Open Neotree" },
	},
	opts = {
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
}}

return specs
