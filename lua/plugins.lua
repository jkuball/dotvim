-- Packer Bootstrap by https://alpha2phi.medium.com/neovim-for-beginners-init-lua-45ff91f741cb#8c33

local Module = {}

function Module.setup()
    -- Indicate first time installation
    local packer_bootstrap = false

    -- packer.nvim configuration
    local conf = {
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "rounded" })
            end,
        },
    }

    -- Check if packer.nvim is installed
    -- Run PackerCompile if there are changes in this file
    local function packer_init()
        local fn = vim.fn
        local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
        if fn.empty(fn.glob(install_path)) > 0 then
            packer_bootstrap = fn.system({
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path,
            })
            vim.cmd([[packadd packer.nvim]])
        end
        vim.cmd("autocmd BufWritePost plugins.lua source <afile> | PackerCompile")
    end

    -- Plugins
    local function plugins(use)
        use("wbthomason/packer.nvim")

        use("https://github.com/tpope/vim-unimpaired")

        -- TODO: https://github.com/kylechui/nvim-surround
        -- TODO: https://github.com/numToStr/Comment.nvim

        use({
            "neovim/nvim-lspconfig",
            config = function()
                require("config.lspconfig").setup()
            end,
        })

        if packer_bootstrap then
            print("Restart Neovim required after installation!")
            require("packer").sync()
        end
    end

    packer_init()

    local packer = require("packer")
    packer.init(conf)
    packer.startup(plugins)
end

return Module
