--- @type LazyPluginSpec[]
local specs = {{
	"saadparwaiz1/cmp_luasnip",
	name = "cmp:luasnip",
	branch = "master",
	event = "User load_cmp_sources",
}}

return specs
