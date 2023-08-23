-- I am not a fan of Lspsaga's show_line_diagnostics,
-- maybe there is a better way / plugin?

local function load_language_servers(opts)
    local lsp = require("lspconfig")
    local lsp_format = require("lsp-format")

    local wk = require("which-key")
    wk.register({
        c = {
            i = {
                function()
                    vim.lsp.inlay_hint(0, nil)
                end,
                "Toggle Inlay Type Hints",
            },
        },
    }, { prefix = "<Leader>" })

    -- TODO: Split this function, maybe into different files.
    -- What about 'lua/lsp/$LANGUAGE.lua'?

    local on_attach = function(client, bufnr)
        lsp_format.on_attach(client)

        -- Enable Inlay Hints by default, if supported.
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(bufnr, true)
        end
    end

    -- TODO: Order?
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- $ brew install lua-language-server
    lsp.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                semantic = {
                    -- Disable semantic syntax highlighting to avoid flickering.
                    enable = false,
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

    -- $ :MasonInstall buf-language-server
    lsp.bufls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {},
    })

    -- $ brew install pyright
    lsp.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {}, -- venv is set by venv-selector.nvim
    })

    -- $ brew install yaml-language-server
    lsp.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
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
        on_attach = on_attach,
        capabilities = capabilities,
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

    -- $ npm i -g angular-language-server
    lsp.angularls.setup({
        on_attach = on_attach,
    })

    -- $ npm i -g typescript-language-server
    lsp.tsserver.setup({
        on_attach = on_attach,
    })
end

return {
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {},
    },
    {
        "folke/neodev.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        -- TODO: event BufReadPre
        opts = {},
        config = function(_, opts)
            load_language_servers(opts)

            local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
            }

            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            vim.diagnostic.config({
                virtual_text = true,
                float = { border = "rounded" },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserEnableOmnifunc", {}),
                callback = function(event)
                    local common_map_options = { noremap = true, silent = true }

                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                    require("which-key").register({
                        c = {
                            name = "+code",
                            a = { vim.lsp.buf.code_action, "LSP Code Action" },
                            r = { vim.lsp.buf.rename, "LSP Rename Symbol" },
                        },
                    }, { prefix = "<Leader>" })

                    -- Brain Compatibility Mapping(s)
                    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, common_map_options)
                end,
            })
        end,
        dependencies = {
            "lukas-reineke/lsp-format.nvim",
            "folke/neodev.nvim",
            { "williamboman/mason-lspconfig.nvim", opts = {} },
        },
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
                    require("which-key").register({
                        d = { "<cmd>Lspsaga goto_definition<cr>", "Go To Definition" },
                        D = { "<cmd>Lspsaga goto_type_definition<cr>", "Go To Type Definition" },
                        r = { "<cmd>Telescope lsp_references<cr>", "Show References" },
                    }, { prefix = "g" })
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
    {
        "lewis6991/hover.nvim",
        init = function()
            -- Setup keymaps
            vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
            vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
        end,
        opts = {
            init = function()
                require("hover.providers.lsp")
                require("hover.providers.gh")
                require("hover.providers.gh_user")
                require("hover.providers.man")
                -- require('hover.providers.dictionary')
            end,
        },
    },
}
