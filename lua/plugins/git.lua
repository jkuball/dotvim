-- Consider replacing vim-gitgutter with gitsigns.nvim (it also provices a blame line).
-- - https://github.com/lewis6991/gitsigns.nvim

return {
    "tpope/vim-fugitive",
    "airblade/vim-gitgutter",
    {
        "tveskag/nvim-blame-line",
        event = "VeryLazy",
        config = function()
            require("which-key").register({
                g = {
                    name = "+git",
                    b = { vim.cmd.ToggleBlameLine, "Toggle Blame Line" },
                },
            }, { prefix = "<Leader>" })
        end,
    },
}
