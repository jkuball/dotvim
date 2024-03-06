local utils = require("heirline.utils")
local conditions = require("heirline.conditions")

local M = {}

--- @type { provider: string }
M.align = { provider = "%=" }

--- @return string
function M.highlight_if_active()
	if conditions.is_active() then
		return "StatusLine"
	end
	return "StatusLineNC"
end

--- @param len number
function M.spacing(len)
	return { provider = string.rep(" ", len) }
end

--- @param statusline table
--- @param len number
function M.spaced(statusline, len)
	return utils.insert(
		statusline,
		{ provider = string.rep(" ", len) }
	)
end

--- @type table<string, boolean>
local _plugin_cache = {}

--- @param plugin string
function M.mark_as_loaded(plugin)
	_plugin_cache[plugin] = true
end

--- @param plugin string
function M.is_loaded(plugin)
	return _plugin_cache[plugin] == true
end

return M
