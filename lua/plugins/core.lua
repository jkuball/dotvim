-- Look into the whole org x nvim situation.
-- - https://github.com/nvim-neorg/neorg
-- - https://github.com/nvim-orgmode/orgmode
-- - what about org-roam?
-- - https://github.com/renerocksai/telekasten.nvim

-- Look into a Highlighter plugin.
-- That might be helpful for pair programming and such.
-- - https://github.com/Pocco81/high-str.nvim

-- Add Todo-Comments, which looks really nice (incl. Trouble & Telescope support).
-- - https://github.com/folke/todo-comments.nvim

-- Look into using sessions.
-- - https://github.com/folke/persistence.nvim
-- - https://github.com/tpope/vim-obsession

-- Look into mason.nvim.
-- - https://github.com/williamboman/mason.nvim

-- Think about whether which-key is something I want.
-- - https://github.com/folke/which-key.nvim

-- Interesting other plugins I want to look into:
-- - https://github.com/nvim-pack/nvim-spectre
-- - https://github.com/RRethy/vim-illuminate
-- - https://github.com/echasnovski/mini.nvim

return {
    "tpope/vim-apathy",
    "tpope/vim-characterize",
    "tpope/vim-dispatch",
    "tpope/vim-eunuch",
    "tpope/vim-repeat",
    "tpope/vim-vinegar",
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.x",
        config = function()
            require("config.telescope").setup()
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "olacin/telescope-gitmoji.nvim",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        config = function()
            require("config.treesitter").setup()
        end,
    },
    {
        "folke/trouble.nvim",
        config = function()
            require("config.trouble").setup()
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },
}