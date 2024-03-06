--- @type LazyPluginSpec[]
return {{
	dir = "lua/plugins/languageservers/rust_analyzer",
	name = "lsp:rust_analyzer",
	ft = "rust",
	config = function()
		require("lspconfig").rust_analyzer.setup({
			capabilities = require("dotvim.common").get_lsp_capabilities(),
			settings = {
				['rust-analyzer'] = {
				}
			},
		})
	end,
}}
