--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/hrsh7th/cmp-buffer",
	name = "cmp:buffer",
	branch = "main",
	event = "User load_cmp_sources",
}}

return specs
