local colorscheme = "catppuccin-frappe"

local function maybe_enable(c)
    if c == colorscheme then
        vim.cmd.colorscheme(c)
    end
end

return {
    {
        "NTBBloodbath/doom-one.nvim",
        priority = 9001, -- load colorschemes before everything else.
        init = function()
            -- These are all configuration options of doom-one,
            -- even if I am setting them to their default.
            vim.g.doom_one_enable_treesitter = true
            vim.g.doom_one_terminal_colors = true
            vim.g.doom_one_italic_comments = true
            vim.g.doom_one_transparent_background = false
            vim.g.doom_one_cursor_coloring = true
            vim.g.doom_one_telescope_highlights = true

            maybe_enable("doom-one")
        end,
    },
    {
        "andreasvc/vim-256noir",
        priority = 9001, -- load colorschemes before everything else.
        init = function()
            maybe_enable("256_noir")
        end,
    },
    {
        "catppuccin/nvim",
        priority = 9001, -- load colorschemes before everything else.
        init = function()
            maybe_enable("catppuccin")
            maybe_enable("catppuccin-latte")
            maybe_enable("catppuccin-frappe")
            maybe_enable("catppuccin-macchiato")
            maybe_enable("catppuccin-mocha")
        end,
    },
    {
        "https://github.com/rcarriga/nvim-notify",
        event = "VimEnter",
        opts = {
            top_down = false,
        },
        init = function()
            vim.notify = require("notify")
        end,
    },
    {
        "rebelot/heirline.nvim",
        event = "VimEnter",
        config = function()
            require("config.heirline").setup()
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
