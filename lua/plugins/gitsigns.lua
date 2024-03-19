--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/lewis6991/gitsigns.nvim",
	version = "^0.7",
	event = "VeryLazy",
	opts = {
		signcolumn = true,
		numhl = true,
		linehl = false,
		current_line_blame = true,
		--- @param bufnr number
		on_attach = function(bufnr)
			local gs = require("gitsigns.actions")
			local wk = require("which-key")

			--- Helper to create toggleable which-key settings.
			--- TODO: If I ever need this in at least two other places, make it generic.
			--- @param toggler fun(boolean)
			--- @param what string
			local function toggle(toggler, what)
				local function wrapper()
					local state = toggler()
					print(what .. ' switched ' .. (state and 'on' or 'off'))
				end
				return { wrapper, "Toggle " .. what, buffer = bufnr, }
			end

			-- TODO: I really can't get it to name the which-key '<Leader>g' prefix '+git'.
			wk.register({
				[']c'] = { function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return "<Ignore>"
				end, "Go To Next Hunk [git]", expr = true, buffer = bufnr},
				['[c'] = { function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.prev_hunk() end)
					return "<Ignore>"
				end, "Go To Previous Hunk [git]", expr = true, buffer = bufnr},
				['<Leader>ga'] = { gs.stage_hunk, "Stage Hunk", buffer = bufnr },
				['<Leader>gs'] = { gs.stage_hunk, "Stage Hunk", buffer = bufnr },
				['<Leader>gS'] = { gs.stage_buffer, "Stage Buffer", buffer = bufnr },
				['<Leader>gA'] = { gs.stage_buffer, "Stage Buffer", buffer = bufnr },
				['<Leader>gr'] = { gs.reset_hunk, "Reset Hunk", buffer = bufnr },
				['<Leader>gR'] = { gs.reset_buffer, "Reset Buffer", buffer = bufnr },
				['<Leader>gp'] = { gs.preview_hunk, "Preview Hunk", buffer = bufnr },
				['<Leader>gu'] = { gs.undo_stage_hunk, "Undo Stage Hunk", buffer = bufnr },
				['<Leader>gb'] = { function() gs.blame_line({full = true}) end, "Show Hunk Blame for Line", buffer = bufnr },
				['<Leader>gd'] = { gs.diffthis, "Show Diff against Index", buffer = bufnr },
				['<Leader>gD'] = { function() gs.diffthis('~') end, "Show Diff against HEAD", buffer = bufnr },
				['<Leader>gob'] = toggle(gs.toggle_current_line_blame, "Current Line Blame"),
				['<Leader>gon'] = toggle(gs.toggle_numhl, "Number Highlight"),
				['<Leader>goh'] = toggle(gs.toggle_linehl, "Line Highlight"),
				['<Leader>gos'] = toggle(gs.toggle_signs, "Git Signs"),
				['<Leader>god'] = toggle(gs.toggle_deleted, "Deleted Hunks"),
			})

			wk.register({
				['<Leader>gs'] = { function() gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, "Stage Hunk Selection", mode = {'v'} },
				['<Leader>gr'] = { function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, "Reset Hunk Selection", mode = {'v'} },
			})

			-- TODO: I didn't get the hunk textobject to work with which-key.
			-- NOTE: 'ah' is a stretch and not really an 'around' text object. Do I really want it like that?
			vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr })
			vim.keymap.set({'o', 'x'}, 'ah', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr })
		end
	},
}}

return specs
