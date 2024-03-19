local utils = require("heirline.utils")
local conditions = require("heirline.conditions")

return {
	condition = conditions.is_git_repo,
	hl = { fg = utils.get_highlight("Constant").fg },
	init = function(self)
		self.head = vim.b.gitsigns_head
	end,
	on_click = {
		name = "heirline_git_branch_picker",
		callback = function()
			require("telescope.builtin").git_branches()
		end,
	},
	{
		provider = function(self)
			return " " .. self.head
		end,
		hl = { bold = true },
	},
}
