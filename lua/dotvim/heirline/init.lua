local conditions = require('heirline.conditions')
local myutils = require('dotvim.heirline.utils')

-- TODO: look into what a "metatable" is and if it will help here somehow
local CurrentFile = require('dotvim.heirline.components.currentfile')
local Filename = require('dotvim.heirline.components.filename')
local GitBranch = require('dotvim.heirline.components.git-branch')
local Harpoon = require('dotvim.heirline.components.harpoon')
local Navic = require('dotvim.heirline.components.navic')
local Ruler = require('dotvim.heirline.components.ruler')
local Scrollbar = require('dotvim.heirline.components.scrollbar')
local ViMode = require('dotvim.heirline.components.vimode')

local StatusLine = {
	ViMode,
	myutils.spaced(CurrentFile, 2, 2),
	myutils.spaced(GitBranch, 0, 2),
	myutils.spaced(Harpoon, 0, 2),
	myutils.align,
	myutils.spaced(Ruler, 0, 2),
	myutils.spaced(Scrollbar, 0, 2),
}

local InactiveStatusLine = {
	condition = conditions.is_not_active,
	myutils.spacing(5),
	CurrentFile,
}

local Winbar = {
	Filename,
	myutils.spacing(1),
	Navic,
}

local InactiveWinbar = {
	condition = conditions.is_not_active,
	Filename,
}

return {
	statusline = {
		hl = myutils.highlight_if_active,
		fallthrough = false,
		InactiveStatusLine,
		StatusLine,
	},
	winbar = {
		hl = myutils.highlight_if_active,
		fallthrough = false,
		InactiveWinbar,
		Winbar,
	},
	tabline = nil,
	statuscolumn = nil,
	--- @param args { file: string }
	--- @return boolean
	disable_winbar_cb = function(args)
		-- only show the winbar for 'real files'.
		-- TODO: Currently I am using th winbar more-or-less only for nvim-navic.
		--       So, I could and should find a better disable condition.
		local readable = vim.fn.filereadable(args.file) == 1
		return not readable
	end,
}
