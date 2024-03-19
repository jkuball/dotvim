--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/hrsh7th/cmp-path",
	name = "cmp:path",
	branch = "main",
	event = "User load_cmp_sources",
}}

return specs
