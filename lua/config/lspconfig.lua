local Module = {}

function Module.on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Use LSP as 'keywordprg' replacement.
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

    -- Goto de{fini,clara}tions
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)

    -- Rename symbols. TODO: Find a(nother?) sensible bind for this.
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
end

function Module.setup()
    local lsp = require("lspconfig")

    -- TODO: Split this function, maybe into different files.
    -- What about 'lua/config/lsp/$LANGUAGE.lua'?

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
                    -- TODO: This doesn't work, I think.
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    -- Silence annoying messages (See https://github.com/neovim/nvim-lspconfig/issues/1700)
                    checkThirdParty = false,
                },
                telemetry = {
                    -- Do not send telemetry data containing a randomized but unique identifier
                    enable = false,
                },
            },
        },
    })
end

return Module
