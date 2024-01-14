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
                    vim.lsp.inlay_hint.enable(0, nil)
                end,
                "Toggle Inlay Type Hints",
            },
        },
    }, { prefix = "<Leader>" })

    -- TODO: Split this function, maybe into different files.
    -- What about 'lua/lsp/$LANGUAGE.lua'?

    local on_attach = function(client, bufnr)
        lsp_format.on_attach(client)

        if client.server_capabilities.documentSymbolProvider then
            local navic = require("nvim-navic")
            navic.attach(client, bufnr)
        end

        -- Enable Inlay Hints by default, if supported.
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(bufnr, true)
        end
    end

    -- TODO: Order?
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- $ :MasonInstall install lua-language-server
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

    -- $ :MasonInstall pyright
    lsp.pyright.setup({
        on_attach = function(client, bufnr)
            -- Set python interpreter path for pyright,
            -- see https://github.com/microsoft/pyright/discussions/6068.
            local handle = io.popen("which python")
            if not handle then
                return
            end
            local output = handle:read("*a"):gsub("[\n\r]", "")
            handle:close()
            vim.defer_fn(function()
                vim.cmd("PyrightSetPythonPath " .. output)
            end, 1)

            on_attach(client, bufnr)
        end,
        capabilities = (function()
            -- disable 'hints' from pyright, since they interfere with ruff and other linters.
            -- code from https://www.reddit.com/r/neovim/comments/11k5but/how_to_disable_pyright_diagnostics/
            local local_capabilities = vim.lsp.protocol.make_client_capabilities()
            local_capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return vim.tbl_deep_extend("force", local_capabilities, capabilities)
        end)(),
        settings = {
            pyright = {
                autoImportCompletions = true,
            },
            python = {
                analysis = {
                    typeCheckingMode = "basic", -- "strict" is a little too strict. But sometimes interesting to see, can I implement some kind of toggle?
                },
            },
        },
    })

    -- $ :MasonInstall yaml-language-server
    lsp.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {},
    })

    -- $ :MasonInstall rust-analyzer
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

    -- $ :MasonInstall angular-language-server
    lsp.angularls.setup({
        on_attach = on_attach,
    })

    -- $ :MasonInstall typescript-language-server
    lsp.tsserver.setup({
        on_attach = function(client, bufnr)
            -- disable tsservers formatting capabilities
            client.resolved_capabilities.document_formatting = false
            on_attach(client, bufnr)
        end,
    })

    -- $ MasonInstall texlab
    lsp.texlab.setup({})

    -- $ :MasonInstall efm
    -- See online documentation for preconfigured linters / formatters and pick what you like:
    -- - https://github.com/creativenull/efmls-configs-nvim/blob/main/doc/SUPPORTED_LIST.md
    local languages = {
        python = {
            -- $ :MasonInstall ruff
            require("efmls-configs.linters.ruff"),
            require("efmls-configs.formatters.ruff"),
        },
        typescript = {
            require("efmls-configs.linters.eslint"),
        },
    }
    local efmls_config = {
        filetypes = vim.tbl_keys(languages),
        settings = {
            rootMarkers = { ".git/" },
            languages = languages,
        },
        init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
        },
    }
    lsp.efm.setup(vim.tbl_extend("force", efmls_config, {
        on_attach = on_attach,
        capabilities = capabilities,
    }))
end

return {
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "folke/neodev.nvim",
    },
    {
        "neovim/nvim-lspconfig",
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
            {
                "creativenull/efmls-configs-nvim",
                version = "v1.x.x",
                dependencies = { "neovim/nvim-lspconfig" },
            },
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
        "SmiteshP/nvim-navic",
        event = "VeryLazy",
        opts = {
            click = true,
            highlight = true,
            separator = "  ",
            icons = {
                File = " ",
                Module = " ",
                Namespace = " ",
                Package = " ",
                Class = " ",
                Method = " ",
                Property = " ",
                Field = " ",
                Constructor = " ",
                Enum = " ",
                Interface = " ",
                Function = " ",
                Variable = " ",
                Constant = " ",
                String = " ",
                Number = " ",
                Boolean = " ",
                Array = " ",
                Object = " ",
                Key = " ",
                Null = " ",
                EnumMember = " ",
                Struct = " ",
                Event = " ",
                Operator = " ",
                TypeParameter = " ",
            },
        },
        after = { "nvim-lspconfig" },
        init = function(opts, _)
            require("nvim-navic").setup(opts)

            local highlights = {
                NavicIconsFile = vim.api.nvim_get_hl(0, { name = "@string", link = false }),
                NavicIconsModule = vim.api.nvim_get_hl(0, { name = "@lsp.type.namespace", link = false }),
                NavicIconsNamespace = vim.api.nvim_get_hl(0, { name = "@lsp.type.namespace", link = false }),
                NavicIconsPackage = vim.api.nvim_get_hl(0, { name = "@lsp.type.namespace", link = false }),
                NavicIconsClass = vim.api.nvim_get_hl(0, { name = "@lsp.type.class", link = false }),
                NavicIconsMethod = vim.api.nvim_get_hl(0, { name = "@lsp.type.method", link = false }),
                NavicIconsProperty = vim.api.nvim_get_hl(0, { name = "@lsp.type.property", link = false }),
                NavicIconsField = vim.api.nvim_get_hl(0, { name = "@field", link = false }),
                NavicIconsConstructor = vim.api.nvim_get_hl(0, { name = "@constructor", link = false }),
                NavicIconsEnum = vim.api.nvim_get_hl(0, { name = "@lsp.type.enum", link = false }),
                NavicIconsInterface = vim.api.nvim_get_hl(0, { name = "@lsp.type.type", link = false }),
                NavicIconsFunction = vim.api.nvim_get_hl(0, { name = "@lsp.type.function", link = false }),
                NavicIconsVariable = vim.api.nvim_get_hl(0, { name = "@lsp.type.variable", link = false }),
                NavicIconsConstant = vim.api.nvim_get_hl(0, { name = "@constant", link = false }),
                NavicIconsString = vim.api.nvim_get_hl(0, { name = "@string", link = false }),
                NavicIconsNumber = vim.api.nvim_get_hl(0, { name = "@number", link = false }),
                NavicIconsBoolean = vim.api.nvim_get_hl(0, { name = "@boolean", link = false }),
                NavicIconsArray = vim.api.nvim_get_hl(0, { name = "@lsp.type.struct", link = false }),
                NavicIconsObject = vim.api.nvim_get_hl(0, { name = "@lsp.type.struct", link = false }),
                NavicIconsKey = vim.api.nvim_get_hl(0, { name = "@text.literal", link = false }),
                NavicIconsNull = vim.api.nvim_get_hl(0, { name = "@lsp.type.constant", link = false }),
                NavicIconsEnumMember = vim.api.nvim_get_hl(0, { name = "@lsp.type.enumMember", link = false }),
                NavicIconsStruct = vim.api.nvim_get_hl(0, { name = "@lsp.type.struct", link = false }),
                NavicIconsEvent = vim.api.nvim_get_hl(0, { name = "@constant.builtin", link = false }),
                NavicIconsOperator = vim.api.nvim_get_hl(0, { name = "@operator", link = false }),
                NavicIconsTypeParameter = vim.api.nvim_get_hl(0, { name = "@lsp.type.typeParameter", link = false }),
                NavicText = vim.api.nvim_get_hl(0, { name = "@text.reference", link = false }),
                NavicSeparator = vim.api.nvim_get_hl(0, { name = "@comment", link = false }),
            }

            local bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg

            for group, style in pairs(highlights) do
                vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", style, { bg = bg }))
            end
        end,
    },
    {
        -- TODO: get rid of this (but I like the goto animation..)
        "glepnir/lspsaga.nvim",
        branch = "main",
        opts = {
            lightbulb = {
                sign = false,
                virtual_text = true,
            },
            symbol_in_winbar = {
                enable = false, -- using nvim-navic instead
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspsagaConfig", {}),
                callback = function(_)
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
