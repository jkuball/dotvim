local M = {}

function M.get_lsp_capabilities()
	local cap = require('cmp_nvim_lsp').default_capabilities()
	return vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), cap)
end

return M
