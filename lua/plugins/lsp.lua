local function load_language_servers()
    local lsp = require("lspconfig")
    local lsp_format = require("lsp-format")
    local navbuddy = require("nvim-navbuddy")

    -- TODO: Split this function, maybe into different files.
    -- What about 'lua/lsp/$LANGUAGE.lua'?

    local on_attach = function(client, bufnr)
        lsp_format.on_attach(client)
        navbuddy.attach(client, bufnr)
    end

    -- TODO: Order?
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- $ brew install lua-language-server
    lsp.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
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
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {},
    })

    -- pip install -U jedi-language-server
    lsp.jedi_language_server.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {},
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
end

return {
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- pip install ruff
                    null_ls.builtins.diagnostics.ruff,
                    -- brew install markdownlint-cli
                    null_ls.builtins.formatting.markdownlint,
                    null_ls.builtins.diagnostics.markdownlint,
                    -- brew install prettier
                    null_ls.builtins.formatting.prettier,
                },
            })
        end,
    },
    {
        "folke/neodev.nvim",
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
        dependencies = { "lukas-reineke/lsp-format.nvim", "folke/neodev.nvim", "SmiteshP/nvim-navbuddy" },
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
        "SmiteshP/nvim-navbuddy",
        dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
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
