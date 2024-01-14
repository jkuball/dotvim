-- Look into a Highlighter plugin.
-- That might be helpful for pair programming and such.
-- - https://github.com/Pocco81/high-str.nvim

-- Add Todo-Comments, which looks really nice (incl. Trouble & Telescope support).
-- - https://github.com/folke/todo-comments.nvim

-- Look into using sessions.
-- - https://github.com/folke/persistence.nvim
-- - https://github.com/tpope/vim-obsession

-- Interesting other plugins I want to look into:
-- - https://github.com/nvim-pack/nvim-spectre
-- - https://github.com/RRethy/vim-illuminate
-- - https://github.com/echasnovski/mini.nvim
-- - https://github.com/ecthelionvi/NeoComposer.nvim

return {
    "tpope/vim-apathy",
    "tpope/vim-characterize",
    "tpope/vim-eunuch",
    "tpope/vim-repeat",
    "tpope/vim-unimpaired",
    "tpope/vim-rsi",
    "tpope/vim-speeddating",
    {
        "numToStr/Comment.nvim",
        opts = {},
    },
    {
        "kylechui/nvim-surround",
        opts = {},
    },
    {
        event = "VeryLazy",
        "tpope/vim-dispatch",
    },
    {
        event = "VeryLazy",
        "folke/which-key.nvim",
        opts = {
            window = {
                border = "single",
            },
        },
    },
    {
        event = "VeryLazy",
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },
}
