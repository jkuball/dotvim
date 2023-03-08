local Module = {}

function Module.setup()
    require("lsp_lines").setup()

    -- This plugin replaces neovims default virtual_text diagnostics.
    vim.diagnostic.config({
        virtual_text = false,
    })
end

return Module
