local wk = require("which-key")

-- prefixes for global keys setup by lazy
wk.register({
	f = { name = "+find" },
	h = { name = "+harpoon" },
}, { prefix = "<Leader>" })
