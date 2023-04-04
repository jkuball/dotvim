return {
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
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-c>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "snippy" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "dcampos/cmp-snippy",
            "hrsh7th/cmp-path",
            "dcampos/nvim-snippy",
        },
    },
}
