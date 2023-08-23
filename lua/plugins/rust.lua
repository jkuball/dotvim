return {
    {
        "Saecki/crates.nvim",
        event = "BufReadPost Cargo.toml",
        opts = {},
        config = function(_, opts)
            require("crates").setup(opts)

            -- Setup completion via nvim-cmp.
            local cmp = require("cmp")
            vim.api.nvim_create_autocmd("BufRead", {
                group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
                pattern = "Cargo.toml",
                callback = function()
                    cmp.setup.buffer({ sources = { { name = "crates" } } })
                end,
            })

            -- Custom Hover Source
            require("hover").register({
                name = "Crates",
                enabled = function()
                    return vim.fn.expand("%:t") == "Cargo.toml"
                end,
                priority = 9001,
                execute = function(done)
                    -- TODO: This circumvents hover.nvim and just calls show_popup() from crates.nvim.
                    -- It has some problems, and maybe it is better to move this logic to K itself.

                    if require("crates").popup_available() then
                        require("crates").show_popup()
                    end

                    -- This stops other hover handlers from being called, but it opens two different popups at the same time.
                    -- Fortunately, it seems like the crates popup is always in front.
                    done({ lines = { "Press `<C-W><C-W>` to get to the crates hover." }, filetype = "markdown" })
                end,
            })
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            "lewis6991/hover.nvim",
        },
    },
}
