return {
    {
        "NTBBloodbath/doom-one.nvim",
        priority = 9001, -- load the main colorscheme before everything else.
        init = function()
            -- These are all configuration options of doom-one,
            -- even if I am setting them to their default.
            vim.g.doom_one_enable_treesitter = true
            vim.g.doom_one_terminal_colors = true
            vim.g.doom_one_italic_comments = true
            vim.g.doom_one_transparent_background = false
            vim.g.doom_one_cursor_coloring = true
            vim.g.doom_one_telescope_highlights = true

            vim.cmd.colorscheme("doom-one")
        end,
    },
    {
        "https://github.com/rcarriga/nvim-notify",
        opts = {
            top_down = false,
        },
        init = function()
            vim.notify = require("notify")
        end,
    },
    {
        "rebelot/heirline.nvim",
        config = function()
            require("config.heirline").setup()
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
