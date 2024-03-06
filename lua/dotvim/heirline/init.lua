local conditions = require('heirline.conditions')
local myutils = require('dotvim.heirline.utils')

local ViMode = require('dotvim.heirline.components.vimode')
local CurrentFile = require('dotvim.heirline.components.currentfile')
local GitBranch = require('dotvim.heirline.components.git-branch')
local Scrollbar = require('dotvim.heirline.components.scrollbar')
local Ruler = require('dotvim.heirline.components.ruler')

local StatusLine = {
	ViMode,
	myutils.spacing(2),
	CurrentFile,
	myutils.spacing(2),
	GitBranch,
	myutils.align,
	Ruler,
	myutils.spacing(2),
	Scrollbar,
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
