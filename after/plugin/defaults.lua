local wk = require("which-key")

-- prefixes for global keys setup by lazy
wk.register({
	f = { name = "+find" },
	h = { name = "+harpoon" },
	x = { name = "+trouble" },
}, { prefix = "<Leader>" })

-- natural openings
vim.o.splitright = true
vim.o.splitbelow = true
