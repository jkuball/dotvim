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
--- @param before number
--- @param after number
function M.spaced(statusline, before, after)
	return utils.insert(
		M.spacing(before),
		statusline,
		M.spacing(after)
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
