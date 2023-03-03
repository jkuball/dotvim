local Module = {}

function Module.on_attach(client, bufnr)
    -- TODO: Do something here.
end

function Module.setup()
    local lsp = require("lspconfig")

    lsp.lua_ls.setup({
        on_attach = Module.on_attach,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    -- Silence annoying messages (See https://github.com/neovim/nvim-lspconfig/issues/1700)
                    checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return Module
