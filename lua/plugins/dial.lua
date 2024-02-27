--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/monaqa/dial.nvim",
	branch = "master", -- Whilst this plugin HAS tags, they are lagging profundly behind.
	keys = {
		{ "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  mode = "n" },
		{ "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, mode = "n" },
		{ "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  mode = "v" },
		{ "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v" },
		{ "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  mode = "n" },
		{ "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, mode = "n" },
		{ "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  mode = "v" },
		{ "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v" },
	},
}}

return specs
