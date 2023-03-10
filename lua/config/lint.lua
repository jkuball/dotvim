local Module = {}

function Module.setup()
    require("lint").linters_by_ft = {
        python = { "ruff" },
    }

    -- Set up lint on opening & writing a file
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufWritePost" }, {
        callback = function()
            require("lint").try_lint(nil, { ignore_errors = true })
        end,
    })

    -- TODO: Make a :Lint command (?) to lint "loud", e.g. with 'ignore_errors = false'.
end

return Module
