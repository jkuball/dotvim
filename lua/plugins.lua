local Module = {}

-- Consider changing back from Neogit to fugitive.
-- - https://github.com/tpope/vim-fugitive
-- - https://github.com/tpope/vim-rhubarb

function Module.plugins(use)
    -- tpope essentials
    use("tpope/vim-apathy")
    use("tpope/vim-characterize")
    use("tpope/vim-eunuch")
    use("tpope/vim-fugitive")
    use("tpope/vim-repeat")
    use("tpope/vim-rsi")
    use("tpope/vim-speeddating")
    use("tpope/vim-unimpaired")
    use("tpope/vim-vinegar")

    use("airblade/vim-gitgutter")

    use({
        "rebelot/heirline.nvim",
        -- You can optionally lazy-load heirline on UiEnter
        -- to make sure all required plugins and colorschemes are loaded before setup
        -- event = "UiEnter",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("config.heirline").setup()
        end,
    })

    use({
        "NTBBloodbath/doom-one.nvim",
        config = function()
            require("config.doom-one").setup()
        end,
    })

    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("config.lspconfig").setup()
        end,
    })

    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("config.lsp_lines").setup()
        end,
    })

    use({
        "j-hui/fidget.nvim",
        config = function()
            require("config.fidget").setup()
        end,
    })

    use({
        "numToStr/Comment.nvim",
        config = function()
            require("config.comment").setup()
        end,
    })

    use({
        "kylechui/nvim-surround",
        config = function()
            require("config.surround").setup()
        end,
    })

    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.x",
        config = function()
            require("config.telescope").setup()
        end,
        requires = {
            "nvim-lua/plenary.nvim",
        },
    })

    use({
        "olacin/telescope-gitmoji.nvim",
        module = "telescope",
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        config = function()
            require("config.treesitter").setup()
        end,
    })

    use({
        "mfussenegger/nvim-lint",
        config = function()
            require("config.lint").setup()
        end,
    })

    use({
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("config.trouble").setup()
        end,
    })
end

return Module
