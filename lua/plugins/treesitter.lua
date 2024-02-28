--- @class TreeSitterConfig: table
--- @see type TSConfig (not usable here because it is not partial)

--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/nvim-treesitter/nvim-treesitter",
	version = "^0.9.2",
	lazy = false,
	build = function()
		vim.cmd.TSUpdate()

		-- NOTE: This is my "fix" for the slow startup time when I am using 'ensure_installed'.
		-- A slight caveat is that this reinstalls the parsers everytime lazy builds this plugin.
		-- Sadly, treesitter doesn't expose the is_installed or install functions, so no chance to make it better, I think.
		vim.cmd.TSInstall({"c", "lua", "vim", "vimdoc", "query", bang = true})
	end,
	--- @type TreeSitterConfig
	opts = {
		additional_vim_regex_highlighting = false,
		auto_install = true, -- when opening a new filetype, load & activate the parser
		ensure_installed = {}, -- using this introduces noticeable lag on my work machine, maybe it's because of the antivirus, maybe not
		sync_install = false,
		highlight = {
			enable = true,
		},
	},
}}

return specs

