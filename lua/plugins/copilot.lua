--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/zbirenbaum/copilot.lua",
	branch = "master", -- no versions to be found
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		suggestion = { enabled = false },
		panel = { enabled = false },
		filetypes = {
			-- disable for .env files
			sh = function()
				return not string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*")
			end,
			-- enable for everything else
			["*"] = true,

			-- TODO: maybe there are some filetypes I don't want it in.
		},
	},
}}

return specs
