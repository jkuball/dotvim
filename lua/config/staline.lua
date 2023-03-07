local Module = {}

function Module.setup()
    -- Statusline
    require("staline").setup({
        sections = {
            left = { "- ", "-mode", " ", "branch" },
            mid = { "lsp" },
            right = { "file_name", "line_column" },
        },
        defaults = {
            left_separator = "",
            right_separator = "|",
            line_column = "[%l/%L]",
        },
    })

    -- NOTE: Staline also provides a Tabline,
    -- but I don't like it's default setup.
    -- TODO: Configure this to my liking.
    -- require("stabline").setup({})
end

return Module
