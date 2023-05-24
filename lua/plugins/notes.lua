-- - https://github.com/renerocksai/telekasten.nvim
-- - https://github.com/nvim-neorg/neorg
-- But overall, I think the nvim-orgmode plugin might be the best way of keeping organization in neovim.

-- Look into:
-- - https://github.com/jubnzv/mdeval.nvim
-- - lukas-reineke/headlines.nvim

local home = vim.fn.expand("~/game-of-life/")

local templates = {}
templates.recipe = [[

* %^{Rezeptname} :recipe:
%u

Link: %x

** Zutaten
** Rezept

   %?
]]

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
                r = {
                    description = "Recipe",
                    template = templates.recipe,
                    target = home .. "/cookbook.org",
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
            require("which-key").register({
                o = { name = "org" },
            }, { prefix = "<Leader>" })
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

            local wk = require("which-key")
            wk.register({
                ["<Leader>of"] = { require("telescope").extensions.orgmode.search_headings, "org heading" },
            })
        end,
    },
}
