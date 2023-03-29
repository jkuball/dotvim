local Module = {}

-- Look into the whole org x nvim situation
-- - https://github.com/nvim-neorg/neorg
-- - https://github.com/nvim-orgmode/orgmode
-- - what about org-roam?
-- - https://github.com/renerocksai/telekasten.nvim

-- Consider replacing vim-gitgutter with gitsigns.nvim.
-- - https://github.com/lewis6991/gitsigns.nvim

-- Look into null-ls
-- - https://github.com/jose-elias-alvarez/null-ls.nvim

-- Look into an auto-completion plugin.
-- In the past I was against this, but working with VSCode might have changed me.
-- - https://github.com/hrsh7th/nvim-cmp/

-- Look into build mechanisms.
-- Is it good enough to use 'makeprg' with vim-dispatch?
-- Do I want something more neovim-native?
-- - https://github.com/neomake/neomake

-- Look into LspSaga
-- - https://github.com/glepnir/lspsaga.nvim

-- Look into a Highlighter plugin, might be helpful for pair programming and such.
-- - https://github.com/Pocco81/high-str.nvim
function Module.plugins(use)
    -- tpope essentials
    use("tpope/vim-apathy")
    use("tpope/vim-characterize")
    use("tpope/vim-dispatch")
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
