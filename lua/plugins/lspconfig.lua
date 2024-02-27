-- @type LazyPluginSpec[]
local specs = {{
	-- specific language servers reside in their own file each,
	-- this file is just to setup everything that is needed by every lsp.
	--- @see readme lua/plugins/languageservers/README.md
	import = "plugins.languageservers"
},
{
	"https://github.com/neovim/nvim-lspconfig",
	branch = "master",
	cmd = {"LspInfo", "LspLog", "LspStart", "LspRestart", "LspStop"},
	keys = {
		{ "<Leader>e", vim.diagnostic.open_float, desc = "Show Line Diagnostics" },
		{ "]e", vim.diagnostic.goto_next, desc = "Go To Next Diagnostic" },
		{ "[e", vim.diagnostic.goto_prev, desc = "Go To Previous Diagnostic" },
	},
	config = function()
		require("mason").setup({})
		require("mason-lspconfig").setup({ automatic_installation = true })
		require("fidget").setup({})

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
				vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
				vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set('n', '<space>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
				vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
				vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
				vim.keymap.set('n', '<space>Q', function()
					vim.lsp.buf.format { async = true }
				end, opts)
			end,
		})
	end,
	dependencies = {
		{
			"https://github.com/j-hui/fidget.nvim",
			version = "^1.4.0",
		},
	}
}}

return specs
