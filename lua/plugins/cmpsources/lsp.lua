--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	name = "cmp:lsp",
	branch = "main",
	event = "User load_cmp_sources",
}}

return specs
