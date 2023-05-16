return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = function()
        require("venv-selector").setup({})

        vim.api.nvim_create_autocmd("VimEnter", {
            desc = "Auto-Select Virtualenv on Start",
            pattern = "*.py",
            callback = function()
                require("venv-selector").retrieve_from_cache()
            end,
            once = true,
        })
    end,
}
