local function load_language_servers()
    local lsp = require("lspconfig")

    -- TODO: Split this function, maybe into different files.
    -- What about 'lua/lsp/$LANGUAGE.lua'?

    -- $ brew install lua-language-server
    lsp.lua_ls.setup({
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
    lsp.pyright.setup({
        settings = {},
    })

    -- pip install -U jedi-language-server
    lsp.jedi_language_server.setup({
        settings = {},
    })

    -- $ brew install yaml-language-server
    lsp.yamlls.setup({
        settings = {},
    })

    -- $ brew install rust-analyzer
    -- NOTE: This only runs diagnostics on-save, since it relies on an external call to 'cargo check/clippy'.
    -- I tried some things to make it more feasible to use, but it seems like this is just something you have to work with.
    -- Auto-Save might be a solution, but a autogroup with vim.cmd.write() didn't trigger a re-run of the ckeck command.
    -- Maybe this auto-save plugin works?
    -- - https://github.com/Pocco81/auto-save.nvim
    -- But looking at the source code, it also just uses vim.cmd.write().
    -- TODO: Find out why rust-analyzer reacts when I type ':w' but not if it is called via api.
    lsp.rust_analyzer.setup({
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true,
                },
                check = {
                    command = "clippy",
                },
            },
        },
    })
end

return {
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        init = function()
            local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
            }

            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserEnableOmnifunc", {}),
                callback = function(event)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
                end,
            })
        end,
        config = load_language_servers,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        -- Disabled for now.
        -- I really love the visuals, but they are disorienting while editing something.
        -- TODO: Maybe make this plugin toggleable?
        enabled = false,
        opts = {},
        init = function()
            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = { only_current_line = true },
            })
        end,
    },
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        opts = {
            lightbulb = {
                sign = false,
                virtual_text = true,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspsagaConfig", {}),
                callback = function(event)
                    local bufopts = { noremap = true, silent = true, buffer = event.buf }

                    -- Use LSP Code Actions.
                    vim.keymap.set("n", "<Leader>ca", "<cmd>Lspsaga code_action<cr>", bufopts)

                    -- Rename symbols.
                    vim.keymap.set("n", "<F2>", "<cmd>Lspsaga rename ++project<cr>", bufopts)
                    vim.keymap.set("n", "<Leader>rn", "<cmd>Lspsaga rename ++project<cr>", bufopts)

                    -- Goto definition.
                    vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<cr>", bufopts)

                    -- Inspect the symbol under the cursor. Replace 'keywordprg'.
                    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", bufopts)

                    -- Jump between diagnostics marks (overridden by lspsaga plugin)
                    local common_map_options = { noremap = true, silent = true }
                    vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<cr>", common_map_options)
                    vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", common_map_options)
                end,
            })
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            -- Please make sure you install markdown and markdown_inline parser
            -- TODO: let lazy.nvim make sure
            { "nvim-treesitter/nvim-treesitter" },
        },
    },
}
