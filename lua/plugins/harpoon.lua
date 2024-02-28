
--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/ThePrimeagen/harpoon/",
	branch = "harpoon2", -- currently in rewrite, let's test it. NOTE: Terminal support seems to be missing right now, come back to that later.
	--- @type HarpoonPartialConfig
	opts = {},
	keys = {
		{
			"<Leader>hh",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Toggle Harpoon UI"
		},
		{
			"<Leader>ha",
			function()
				require("harpoon"):list():append()
			end,
			desc = "Toggle Harpoon UI"
		},
		{
			"]h",
			function()
				require("harpoon"):list():next({ui_nav_wrap=true})
			end,
			desc = "Next Harpooned File (wrapping)"
		},
		{
			"[h",
			function()
				require("harpoon"):list():prev({ui_nav_wrap=true})
			end,
			desc = "Prev Harpooned File (wrapping)"
		},
		{ "<Leader>1", function() require("harpoon"):list():select(1) end, desc = "⇁ #1" },
		{ "<Leader>2", function() require("harpoon"):list():select(2) end, desc = "⇁ #2" },
		{ "<Leader>3", function() require("harpoon"):list():select(3) end, desc = "⇁ #3" },
		{ "<Leader>4", function() require("harpoon"):list():select(4) end, desc = "⇁ #4" },
		{ "<Leader>5", function() require("harpoon"):list():select(5) end, desc = "⇁ #5" },
		{ "<Leader>6", function() require("harpoon"):list():select(6) end, desc = "⇁ #6" },
		{ "<Leader>7", function() require("harpoon"):list():select(7) end, desc = "⇁ #7" },
		{ "<Leader>8", function() require("harpoon"):list():select(8) end, desc = "⇁ #8" },
		{ "<Leader>9", function() require("harpoon"):list():select(9) end, desc = "⇁ #9" },
	},
	dependencies = { "https://github.com/nvim-lua/plenary.nvim" },
}}

return specs
