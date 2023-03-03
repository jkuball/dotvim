local Module = {}

function Module.plugins(use)
    use("https://github.com/tpope/vim-unimpaired")

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
