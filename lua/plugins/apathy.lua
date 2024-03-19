--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/tpope/vim-apathy",
	branch = "master", -- no releases, no changes
	event = {"BufNewFile", "BufRead"},
}}

return specs
