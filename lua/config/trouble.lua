local Module = {}

function Module.setup()
    require("trouble").setup({
        use_diagnostic_signs = true,
    })
end

return Module
