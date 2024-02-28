-- @type LazyPluginSpec[]
--
local specs = {{
	-- specific language servers reside in their own file each,
	-- this file is just to setup everything that is needed by every lsp.
	--- @see readme lua/plugins/languageservers/README.md
	import = "plugins.languageservers"
},
{
	"https://github.com/neovim/nvim-lspconfig",
	branch = "master",
	cmd = { "LspInfo", "LspLog", "LspStart", "LspRestart", "LspStop" },
	keys = {
		{ "<Leader>e", vim.diagnostic.open_float, desc = "Show Line Diagnostics" },
		{ "]e",        vim.diagnostic.goto_next,  desc = "Go To Next Diagnostic" },
		{ "[e",        vim.diagnostic.goto_prev,  desc = "Go To Previous Diagnostic" },
	},
	config = function()
		require("mason").setup({})
		require("mason-lspconfig").setup({ automatic_installation = true })
		require("fidget").setup({})

		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(ev)
				vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

				local telescope_builtin = require("telescope.builtin")

				-- buffer local mappings only available after a lsp client attached
				-- TODO: Look into vim.lsp.buf.{add,remove,list}_workspace_folder(s). Is this cool?
				require("which-key").register({
					["gd"] = { vim.lsp.buf.definition, "Go to Definition [lsp]", buffer = ev.buf },
					["gD"] = { vim.lsp.buf.declaration, "Go to Declaration [lsp]", buffer = ev.buf },
					["gT"] = { vim.lsp.buf.type_definition, "Go to Type Definition [lsp]", buffer = ev.buf },
					["gr"] = { vim.lsp.buf.references, "Go to Reference [lsp]", buffer = ev.buf }, -- for finding better use telescope, <Leader>fr
					["K"] = { vim.lsp.buf.hover, "Show Hover Info [lsp]", buffer = ev.buf },
					["<c-k>"] = { vim.lsp.buf.signature_help, "Show Signature Help [lsp]", buffer = ev.buf },
					["<Leader>ca"] = { vim.lsp.buf.code_action, "Run Code Action [lsp]", mode = { "n", "v" }, buffer = ev.buf },
					["<Leader>cr"] = { vim.lsp.buf.rename, "Rename Symbol [lsp]", buffer = ev.buf },
					["Q"] = { function() vim.lsp.buf.format({async = true}) end, "Format File [lsp]", buffer = ev.buf },
					["<Leader>fs"] = { telescope_builtin.lsp_document_symbols, "Find Document Symbols [lsp]", buffer = ev.buf },
					["<Leader>fS"] = { telescope_builtin.lsp_workspace_symbols, "Find Workspace Symbols [lsp]", buffer = ev.buf },
				})
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
