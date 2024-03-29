return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = true,
    event = "VeryLazy",
    keys = {
        {
            "<leader>vs",
            "<cmd>:VenvSelect<cr>",
        },
        {
            "<leader>vc",
            "<cmd>:VenvSelectCached<cr>",
        },
    },
}
