return {
    "tpope/vim-unimpaired",
    "tpope/vim-rsi",
    "tpope/vim-speeddating",
    "godlygeek/tabular",
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")

            cmp.setup({
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
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "snippy" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                experimental = {
                    ghost_text = true,
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
        "numToStr/Comment.nvim",
        opts = {},
    },
    {
        "kylechui/nvim-surround",
        opts = {},
    },
}
