--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/monaqa/dial.nvim",
	branch = "master", -- Whilst this plugin HAS tags, they are lagging profundly behind.
	keys = {
		{ "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  desc = "Smart Increment cWORD", mode = "n" },
		{ "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Smart Increment cWORD", mode = "n" },
		{ "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  desc = "Smart Increment Selection", mode = "v" },
		{ "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, desc = "Incremental Smart Increment Selection", mode = "v" },
		{ "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  desc = "Smart Decrement cWORD", mode = "n" },
		{ "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Smart Decrement cWORD", mode = "n" },
		{ "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  desc = "Smart Decrement Selection", mode = "v" },
		{ "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, desc = "Incremental Smart Decrement Selection", mode = "v" },
	},
}}

return specs
