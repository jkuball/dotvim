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

    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    -- TODO: Split this function, maybe into different files.
    -- What about 'lua/config/lsp/$LANGUAGE.lua'?

    -- $ brew install lua-language-server
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
                    -- TODO: It looks like there are more usual gobals (pairs, etc.)
                    -- that are not recognized by the language server.
                    -- Maybe that is because of this setting?
                    -- Also, there is no introspection of the vim global,
                    -- is there something else I have to configure?
                    -- Maybe this helps: https://github.com/LuaLS/lua-language-server/wiki/Configuration-File#neovim-with-built-in-lsp-client
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
                completion = {
                    -- When there are no completions, don't fallback to mimic <c-x><c-n>
                    showWord = "Disable",
                },
            },
        },
    })

    -- $ brew install pyright
    lsp.pyright.setup({})
end

return Module
