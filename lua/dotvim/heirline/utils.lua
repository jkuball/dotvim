local conditions = require("heirline.conditions")

local M = {}

--- @return string
function M.highlight_if_active()
	if conditions.is_active() then
		return "StatusLine"
	end
	return "StatusLineNC"
end

--- @type { provider: string }
M.align = { provider = "%=" }

--- @param len number
function M.spacing(len)
	return { provider = string.rep(" ", len) }
end

return M
