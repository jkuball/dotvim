local M = {}

-- TODO: Add typehints and docstrings.

M._virtualenvs = {}

function M.get_venv(root_dir)
    -- NOTE: This is a good source for autodetecting virtualenvs, if I ever use more than just plain old poetry.
    -- https://github.com/younger-1/nvim/blob/one/lua/young/lang/python.lua

    local path = require("lspconfig.util").path

    -- Autodetect poetry environment
    if not M._virtualenvs[root_dir] and vim.fn.glob(path.join(root_dir, "poetry.lock")) ~= "" then
        local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
        M._virtualenvs[root_dir] = venv
    end

    return M._virtualenvs[root_dir]
end

function M.narrow_bin(venv, bin)
    local _bin = venv .. "/bin/" .. bin
    if venv and vim.fn.filereadable(_bin) then
        return _bin
    end
    return bin
end

return M
