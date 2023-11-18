return {
    "godlygeek/tabular",
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local lspkind = require("lspkind")
            local cmp = require("cmp")

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        symbol_map = {
                            Copilot = "",
                        },
                    }),
                },
                snippet = {
                    expand = function(args)
                        require("snippy").expand_snippet(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<Up>"] = cmp.mapping.select_prev_item(),
                    ["<Down>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-c>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "snippy" },
                    { name = "path" },
                    { name = "buffer" },
                }),
                experimental = {
                    ghost_text = true,
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        require("copilot_cmp.comparators").prioritize,

                        -- Below is the default comparitor list and order for nvim-cmp
                        cmp.config.compare.offset,
                        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            })

            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
        end,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "dcampos/cmp-snippy",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "dcampos/nvim-snippy",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "petertriho/cmp-git",
            "onsails/lspkind.nvim",
            "zbirenbaum/copilot.lua",
            "zbirenbaum/copilot-cmp",
        },
    },
    {
        "dcampos/nvim-snippy",
        opts = {
            mappings = {
                is = {
                    ["<Tab>"] = "expand_or_advance",
                    ["<S-Tab>"] = "previous",
                },
            },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        -- cmd = "Copilot",
        -- event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                sh = function()
                    -- disable for .env files
                    if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
                        return false
                    end
                    return true
                end,
                ["*"] = true,
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        opts = {},
        config = function(_, opts)
            require("copilot_cmp").setup(opts)
        end,
    },
}
