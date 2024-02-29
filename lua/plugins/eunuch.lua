--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/tpope/vim-eunuch",
	version = "^1.3.0",
	event = "VeryLazy", -- this sets up autocommands for shebangs
}}

return specs
