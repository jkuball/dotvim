--- @type LazyPluginSpec[]
local specs = {{
	"https://github.com/linux-cultist/venv-selector.nvim",
	branch = "main", -- Seems like they don't manage versions really well
	opts = {},
	filetype = "python",
	cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectCurrent" },
	config = function(_, opts)
		require("venv-selector").setup(opts)

		require("which-key").register({
			["<Localleader>vs"] = { "<cmd>VenvSelect<cr>", desc = "Interactively Select a Virtualenv" },
			["<Localleader>vc"] = { "<cmd>VenvSelectCached<cr>", desc = "Select a Virtualenv from Cache " },
		})
	end,
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			desc = "Auto select virtualenv on opening a python file (once per nvim instance)",
			pattern = "python",
			callback = function()
				local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
				if venv ~= "" then
					require("venv-selector").retrieve_from_cache()
				end
			end,
			once = true,
		})
	end
}}

return specs
