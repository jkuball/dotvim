--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/stevearc/oil.nvim",
	version = "^2.6.1",
	event = "VimEnter", -- VeryLazy is too late to open a directory via args.
        opts = {
            keymaps = {
                ["_"] = false, -- I am remapping it in favor of Neotree.
            },
        },
	keys = {
		{ "-", "<cmd>:Oil<cr>", desc = "Open current file's parent directory" },
	},
}}

return specs
