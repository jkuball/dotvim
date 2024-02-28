return {{
	dir = "lua/plugins/languageservers/pyright",
	name = "lsp:pyright",
	ft = "python",
	config = function()
		require("lspconfig").pyright.setup {
			settings = {
				pyright = {
					autoImportCompletions = true,
				},
				python = {
					analysis = {
						typeCheckingMode = "basic", -- "strict" is a little too strict. But sometimes interesting to see, can I implement some kind of toggle?
					},
				},
			},
		}
	end,
}}

-- TODO make pyright faster with stubs: https://github.com/microsoft/pyright/issues/4878#issuecomment-1553156526
