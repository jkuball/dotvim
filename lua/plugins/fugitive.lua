--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/tpope/vim-fugitive",
	version = "^3.7",
	-- TODO: Just a test if it is really feasible to load a plugin with many many lazy loaders (sooo many commands..).
	-- In theory I don't see why fugitive can't be loaded directly at startup.
	cmd = {"G", "Git", "Ggrep", "Glgrep", "Gclog", "Gllog", "Gcd", "Glcd", "Gedit", "Gsplit", "Gvsplit", "Gtabedit", "Gpedit", "Gread", "Gwrite", "Gw", "Gwq", "Gdiffsplit", "Gvdiffsplit", "Ghdiffsplit", "GMove", "GRename", "GDelete", "GRemove", "GUnlink", "GBrowse"},
	keys = {
		{ "<Leader>gg", "<cmd>:tab Git<cr>", desc = "Open Fugitive UI in new tab" },
		{ "<Leader>gG", "<cmd>:Git<cr>", desc = "Open Fugitive UI (normal)" },
	}
}}

return specs
