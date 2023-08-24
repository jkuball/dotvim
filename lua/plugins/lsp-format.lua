return {
    {
        "lukas-reineke/lsp-format.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<Leader>cff",
                "<cmd>:Format<cr>",
                desc = "Format current file",
            },
            {
                "<Leader>cft",
                "<cmd>:FormatToggle<cr>",
                desc = "Toggle Auto-Format on Save",
            },
        },
    },
}
