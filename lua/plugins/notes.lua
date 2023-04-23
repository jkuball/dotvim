-- Other plugins to think about using in the future:
-- - https://github.com/renerocksai/telekasten.nvim
-- - https://github.com/nvim-neorg/neorg
-- But overall, I think the nvim-orgmode plugin might be the best way of keeping organization in neovim.

-- Look into:
-- - https://github.com/jubnzv/mdeval.nvim
-- - lukas-reineke/headlines.nvim

local home = vim.fn.expand("~/game-of-life/")

return {
    {
        "nvim-orgmode/orgmode",
        opts = {
            org_agenda_files = { home .. "/**/*.org" },
            org_default_notes_file = home .. "refile.org",
            org_capture_templates = {
                t = {
                    description = "Todo",
                    template = "* TODO %?\n %u",
                    target = home .. "/todo.org",
                },
                j = {
                    description = "Journal",
                    template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
                    target = home .. "/journal.org",
                },
                l = {
                    description = "Ledger Entry",
                    template = "\n%<%m-%d> %^{Description}\n    %?",
                    target = string.format(home .. "/ledger/%s.ledger", vim.fn.strftime("%Y-%m")),
                    filetype = "ledger",
                },
            },
        },
        init = function()
            require("orgmode").setup_ts_grammar()
            require("org-capture-filetype")
        end,
        dependencies = { "TravonteD/org-capture-filetype" },
    },
    {
        "akinsho/org-bullets.nvim",
        opts = {},
    },
    {
        "andreadev-it/orgmode-multi-key",
        opts = {
            key = "<C-c><C-c>",
        },
    },
    {
        "joaomsa/telescope-orgmode.nvim",
        init = function()
            require("telescope").load_extension("orgmode")

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "org",
                group = vim.api.nvim_create_augroup("UserOrgModeTelescopeNvim", { clear = true }),
                callback = function()
                    vim.keymap.set("n", "<leader>or", require("telescope").extensions.orgmode.refile_heading)
                end,
            })

            local opt = { silent = true, noremap = true }
            vim.keymap.set("n", "<Leader>of", require("telescope").extensions.orgmode.search_headings, opt)
        end,
    },
}
