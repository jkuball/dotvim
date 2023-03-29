local Module = {}

function Module.setup()
    require("lsp_lines").setup()

    -- This plugin replaces neovims default virtual_text diagnostics.
    vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = { only_current_line = true },
    })
end

return Module
