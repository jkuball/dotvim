local wk = require("which-key")

-- prefixes for global keys setup by lazy
wk.register({
	f = { name = "+find" },
	h = { name = "+harpoon" },
}, { prefix = "<Leader>" })

-- allow the detection of a moving mouse for ui stuff
vim.o.mousemoveevent = true
