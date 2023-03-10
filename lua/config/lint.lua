local Module = {}

function Module.setup()
    require("lint").linters_by_ft = {
        python = {
            -- pip install ruff
            "ruff",
        },
        markdown = {
            -- brew install markdownlint-cli
            "markdownlint",
        },
    }

    -- Set up lint on relevant events
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufWritePost", "CursorHold" }, {
        callback = function()
            require("lint").try_lint(nil, { ignore_errors = true })
        end,
    })

    -- TODO: Make a :Lint command (?) to lint "loud", e.g. with 'ignore_errors = false'.
end

return Module
