local Module = {}

function Module.plugins(use)
    use("tpope/vim-unimpaired")
    use("tpope/vim-vinegar")

    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("config.lspconfig").setup()
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
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        config = function()
            require("config.treesitter").setup()
        end,
    })

    use({
        "TimUntersberger/neogit",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("config.neogit").setup()
        end,
    })
end

return Module
