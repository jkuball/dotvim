--- @class TelescopeConfig: table
--- @see nvim-help :h telescope.setup()

--- @type LazyPluginSpec[]
local specs = { {
	"https://github.com/nvim-telescope/telescope.nvim",
	version = "^0.1.5",
	--- @type TelescopeConfig
	opts = {
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = function(bufnr)
						require("telescope.actions").move_selection_next(
							bufnr)
					end,
					["<C-k>"] = function(bufnr)
						require("telescope.actions").move_selection_previous(
							bufnr)
					end,
				},
			},
		},
		extensions = {
			--- @see telescope-fzf-native https://github.com/nvim-telescope/telescope-fzf-native.nvim
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			}
		}
	},
	--- @param opts? TelescopeConfig
	config = function(_, opts)
		require("telescope").setup(opts or {})
		require('telescope').load_extension('fzf')
		require("which-key").register({ f = "+find" }, { prefix = "<Leader>" })
	end,
	cmd = "Telescope",
	keys = {
		{ "<leader>F",  "<cmd>Telescope resume<cr>",                    desc = "Resume last Telescoping" },
		{ "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current Buffer Fuzzy Find" },
		{ "<leader>f:", "<cmd>Telescope commands<cr>",                  desc = "'Command Palette'" },
		{ "<leader>fT", "<cmd>Telescope builtin<cr>",                   desc = "Find builtin telescope pickers" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Find Buffers" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>",               desc = "Find Diagnostics" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
		{ "<leader>fr", "<cmd>Telescope lsp_references<cr>",            desc = "Find LSP References" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Find Help Tags" },
		{ "g#",         "<cmd>Telescope grep_string<cr>",               desc = "Telescope Grep for WORD" },
		{ "g*",         "<cmd>Telescope grep_string<cr>",               desc = "Telescope Grep for WORD" },
	},
	dependencies = {
		{ "https://github.com/nvim-lua/plenary.nvim" },
		{
			"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
			branch = "main",
			build = [[
				cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
				cmake --build build --config Release
				cmake --install build --prefix build
			]],
		}
	}
} }

return specs
