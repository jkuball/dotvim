local utils = require("heirline.utils")

return {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	provider = function(self)
		-- first, trim the pattern relative to the current directory. For other
		-- options, see :h filename-modifers
		local filename = vim.fn.fnamemodify(self.filename, ":t")
		return filename
	end,
	hl = {
		bold = true,
		fg = utils.get_highlight("Function").fg,
	},
}
