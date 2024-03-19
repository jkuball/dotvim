--- @type LazyPluginSpec[]
return {{
	dir = "lua/plugins/languageservers/lua_ls",
	name = "lsp:lua_ls",
	ft = "lua",
	config = function()
		require("neodev").setup({})
		require("lspconfig").lua_ls.setup({
			capabilities = require("dotvim.common").get_lsp_capabilities(),
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = "Disable",
					},
					completion = {
						callSnippet = "Replace"
					}
				},
			},
		})
	end,
	dependencies = {
		"folke/neodev.nvim",
		version = "^2.5.2"
	}
}}
