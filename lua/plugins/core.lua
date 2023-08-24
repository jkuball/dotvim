-- Look into a Highlighter plugin.
-- That might be helpful for pair programming and such.
-- - https://github.com/Pocco81/high-str.nvim

-- Add Todo-Comments, which looks really nice (incl. Trouble & Telescope support).
-- - https://github.com/folke/todo-comments.nvim

-- Look into using sessions.
-- - https://github.com/folke/persistence.nvim
-- - https://github.com/tpope/vim-obsession

-- Maybe get back to using dirvish.
-- - https://github.com/justinmk/vim-dirvish

-- Interesting other plugins I want to look into:
-- - https://github.com/nvim-pack/nvim-spectre
-- - https://github.com/RRethy/vim-illuminate
-- - https://github.com/echasnovski/mini.nvim
-- - https://github.com/ecthelionvi/NeoComposer.nvim

return {
    "tpope/vim-apathy",
    "tpope/vim-characterize",
    "tpope/vim-eunuch",
    "tpope/vim-repeat",
    "tpope/vim-vinegar",
    "tpope/vim-unimpaired",
    "tpope/vim-rsi",
    "tpope/vim-speeddating",
    {
        "numToStr/Comment.nvim",
        opts = {},
    },
    {
        "kylechui/nvim-surround",
        opts = {},
    },
    {
        "tpope/vim-dispatch",
        config = function(_, _)
            local path = require("plenary.path")

            vim.api.nvim_create_autocmd("BufReadPost", {
                group = vim.api.nvim_create_augroup("DispatchLoadStartFromFile", {}),
                callback = function(event)
                    local target = path:new(vim.fs.dirname(event.file)) / "b:start"

                    -- TODO: Set this for the whole filetree below this.

                    if target:exists() then
                        target:read(function(data)
                            vim.b.start = data
                            vim.notify(
                                string.format("Loaded standard dispatch function from '%s'", target:make_relative())
                            )
                        end)
                    end
                end,
            })
        end,
        requires = { "nvim-lua/plenary.nvim" },
    },
    {
        event = "VeryLazy",
        "folke/which-key.nvim",
        opts = {
            window = {
                border = "single",
            },
        },
    },
    {
        event = "VeryLazy",
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },
}
