--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/rcarriga/nvim-notify",
	version = "^3.13.4",
	lazy = false,
	config = function()
		local notify = require("notify")
		notify.setup()
		vim.notify = notify
	end,
}}

return specs
