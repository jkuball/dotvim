--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/petertriho/cmp-git",
	name = "cmp:git",
	branch = "main",
	event = "User load_cmp_sources",
	opts = {},
}}

return specs
