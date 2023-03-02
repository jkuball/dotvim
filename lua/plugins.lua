local Module = {}

function Module.plugins(use)
    use("https://github.com/tpope/vim-unimpaired")

    -- TODO: https://github.com/numToStr/Comment.nvim

    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("config.tree").setup()
        end,
    })

    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("config.lspconfig").setup()
        end,
    })

    use({
        "kylechui/nvim-surround",
        config = function()
            require("config.surround").setup()
        end,
    })
end

return Module
