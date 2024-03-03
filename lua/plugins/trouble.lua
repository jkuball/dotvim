--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/folke/trouble.nvim",
	version = "^2.10.0",
	cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
	keys = {
		{ "<Leader>xx", function() require("trouble").toggle() end,                        desc = "Toggle Trouble" },
		{ "<Leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, desc = "Toggle workspace diagnostics" },
		{ "<Leader>xd", function() require("trouble").toggle("document_diagnostics") end,  desc = "Toggle document diagnostics" },
		{ "<Leader>xq", function() require("trouble").toggle("quickfix") end,              desc = "Toggle quickfix" },
		{ "<Leader>xl", function() require("trouble").toggle("loclist") end,               desc = "Toggle loclist" },
	},
	--- @type TroubleOptions
	opts = {
		action_keys = {
			cancel = {},
			next = {},
			prev = {},
		}
	},
	init = function()
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspTroubleConfig', {}),
			callback = function(ev)
				-- buffer local mappings only available after a lsp client attached
				require("which-key").register({
					["gR"] = { function() require("trouble").toggle("lsp_references") end, "Go to Reference w/ Trouble [lsp]", buffer = ev.buf },
					["]T"] = { function() require("trouble").next({ skip_groups = true, jump = true }) end, "Go to Next Trouble", buffer = ev.buf },
					["[T"] = { function() require("trouble").next({ skip_groups = true, jump = true }) end, "Go to Previous Trouble", buffer = ev.buf },
				})
			end,
		})

		vim.api.nvim_create_autocmd('Filetype', {
			pattern = "Trouble",
			group = vim.api.nvim_create_augroup('UserTroubleConfig', {}),
			callback = function(ev)
				-- buffer local mappings only available in a trouble buffer
				require("which-key").register({
					["<c-j>"] = { function() require("trouble").next({ skip_groups = true, jump = false }) end, "Next Item", buffer = ev.buf },
					["<c-k>"] = { function() require("trouble").previous({ skip_groups = true, jump = false }) end, "Previous Item", buffer = ev.buf },
				})
			end,
		})
	end
}}

return specs
