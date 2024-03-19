--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/zbirenbaum/copilot-cmp",
	name = "cmp:copilot",
	branch = "master",
	event = "User load_cmp_sources",
	opts = {},
}}

return specs
