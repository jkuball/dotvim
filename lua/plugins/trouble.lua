return {
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        opts = {
            use_diagnostic_signs = true,
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<leader>dt",
                "<cmd>:TroubleToggle<cr>",
                desc = "Toggle Diagnostic Browser",
            },
        },
    },
}
