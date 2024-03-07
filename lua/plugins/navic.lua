--- @type LazyPluginSpec[]
local specs = { {
	"https://github.com/SmiteshP/nvim-navic",
	opts = {},
	branch = "master", -- no versions
	init = function()
		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(ev)
				local bufnr = ev.buf
				local client_id = ev.data.client_id
				local client = vim.lsp.get_client_by_id(client_id)
				if client ~= nil and client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
				end
			end
		})
	end
} }

return specs
