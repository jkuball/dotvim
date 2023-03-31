-- Find out why nvim-surround can not be updated anymore.
-- Maybe switch to the good old plugin from tpope?

-- Look into the whole org x nvim situation.
-- - https://github.com/nvim-neorg/neorg
-- - https://github.com/nvim-orgmode/orgmode
-- - what about org-roam?
-- - https://github.com/renerocksai/telekasten.nvim

-- Consider replacing vim-gitgutter with gitsigns.nvim.
-- - https://github.com/lewis6991/gitsigns.nvim

-- Look into null-ls.
-- - https://github.com/jose-elias-alvarez/null-ls.nvim

-- Look into an auto-completion plugin.
-- In the past I was against this, but working with VSCode might have changed me.
-- - https://github.com/hrsh7th/nvim-cmp/

-- Look into build mechanisms.
-- Is it good enough to use 'makeprg' with vim-dispatch?
-- Do I want something more neovim-native?
-- - https://github.com/neomake/neomake

-- Look into a Highlighter plugin.
-- That might be helpful for pair programming and such.
-- - https://github.com/Pocco81/high-str.nvim

-- Look into neodev, and how they configure the lua language server.
-- - https://github.com/folke/neodev.nvim

return {
    "tpope/vim-apathy",
    "tpope/vim-characterize",
    "tpope/vim-dispatch",
    "tpope/vim-eunuch",
    "tpope/vim-fugitive",
    "tpope/vim-repeat",
    "tpope/vim-rsi",
    "tpope/vim-speeddating",
    "tpope/vim-unimpaired",
    "tpope/vim-vinegar",
    "airblade/vim-gitgutter",
    {
        "rebelot/heirline.nvim",
        config = function()
            require("config.heirline").setup()
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "NTBBloodbath/doom-one.nvim",
        config = function()
            require("config.doom-one").setup()
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("config.lspconfig").setup()
        end,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("config.lsp_lines").setup()
        end,
    },
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require("config.lspsaga").setup()
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            -- Please make sure you install markdown and markdown_inline parser
            -- TODO: let lazy.vim make sure
            { "nvim-treesitter/nvim-treesitter" },
        },
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("config.fidget").setup()
        end,
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("config.comment").setup()
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("config.surround").setup()
        end,
    },
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
        "mfussenegger/nvim-lint",
        config = function()
            require("config.lint").setup()
        end,
    },
    {
        "folke/trouble.nvim",
        config = function()
            require("config.trouble").setup()
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}