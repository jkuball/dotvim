local M = {}

-- TODO: Add typehints and docstrings.

M._virtualenvs = {}

function M.narrow_bin(venv, bin)
    local _bin = venv .. "/bin/" .. bin
    if venv and vim.fn.filereadable(_bin) then
        return _bin
    end
    return bin
end

return M
