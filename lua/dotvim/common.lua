local M = {}

function M.get_lsp_capabilities()
	local cap = require('cmp_nvim_lsp').default_capabilities()
	return vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), cap)
end

--- @param opts {[1]: number, use_tabs: boolean?}
function M.set_indentations(opts)
	vim.bo.expandtab = not opts.use_tabs
	vim.bo.shiftwidth = 4
	vim.bo.tabstop = 4
end

return M
