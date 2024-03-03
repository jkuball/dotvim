--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/folke/todo-comments.nvim",
	version = "^1.1.0",
	event = { "BufNewFile", "BufRead" },
	cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope", "TodoTrouble" },
	keys = {
		{ "<Leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
		{ "<Leader>xt", "<cmd>TodoTrouble<cr>", desc = "Toggle TODOs" },
		{ "]t",         vim.diagnostic.goto_next, desc = "Go To Next TODO" },
		{ "[t",         vim.diagnostic.goto_prev, desc = "Go To Previous TODO" },
	},
	--- @type TodoOptions
	opts = {
		signs = false,
		highlight = {
			before = "",
			keyword = "fg",
			after = "",
			pattern = { [[.*<(KEYWORDS)\s*:]], [[ .*<(KEYWORDS)\(.+\)\s*:]]  } -- NOTE that these are verymagic and case sensitive hardcoded by the plugin
		},
		search = {
			pattern = '\\b(KEYWORDS)(\\([[:word:]]+\\))?:',
		}
	},
	--- @param opts TodoOptions
	config = function(_, opts)
		require("todo-comments").setup(opts)

		-- when this plugin is loaded, ignore the 'default' todo highlight.
		-- TODO: I don't know how to remove it completely, so I just map it to comment style.
		vim.api.nvim_set_hl(0, "Todo", { link = "Comment" })
	end,
}}

return specs
