local Module = {}

function Module.setup()
    -- Statusline
    require("staline").setup({
        sections = {
            left = { "- ", "-mode", " ", "file_name", "branch", "diagnostics" },
            mid = {},
            right = {
                { "Staline", Module.fileencoding },
                { "Staline", Module.file_type },
                "line_column",
            },
        },
        defaults = {
            left_separator = "",
            right_separator = "|",
            line_column = "%l/%L",
        },
    })

    -- NOTE: Staline also provides a Tabline,
    -- but I don't like it's default setup.
    -- TODO: Configure this to my liking.
    -- require("stabline").setup({})
end

function Module.fileencoding()
    return " " .. vim.bo.fileencoding .. " "
end

function Module.file_type()
    return " " .. vim.bo.filetype .. " "
end

return Module
