local conditions = require('heirline.conditions')
local myutils = require('dotvim.heirline.utils')

-- TODO: look into what a "metatable" is and if it will help here somehow
local CurrentFile = require('dotvim.heirline.components.currentfile')
local GitBranch = require('dotvim.heirline.components.git-branch')
local Harpoon = require('dotvim.heirline.components.harpoon')
local Ruler = require('dotvim.heirline.components.ruler')
local Scrollbar = require('dotvim.heirline.components.scrollbar')
local ViMode = require('dotvim.heirline.components.vimode')

local StatusLine = {
	ViMode,
	myutils.spacing(2),
	myutils.spaced(CurrentFile, 2),
	myutils.spaced(GitBranch, 2),
	myutils.spaced(Harpoon, 2),
	myutils.align,
	myutils.spaced(Ruler, 2),
	myutils.spaced(Scrollbar, 2),
}

local InactiveStatusLine = {
	condition = conditions.is_not_active,
	myutils.spacing(5),
	CurrentFile,
}

return {
	statusline = {
		hl = myutils.highlight_if_active,
		fallthrough = false,
		InactiveStatusLine,
		StatusLine,
	},
	winbar = nil,
	tabline = nil,
	statuscolumn = nil,
}
