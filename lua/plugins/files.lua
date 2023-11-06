-- Look into https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-files.md
-- Could be a complement to 'oil.nvim'.

return {
    "stevearc/oil.nvim",
    opts = {},
    lazy = false, -- Always load, so 'nvim .' already uses it. Can probably be fixed to 'only load on opening a directory' or something like that.
    keys = {
        { "-", "<cmd>:Oil<cr>", desc = "Open parent directory" },
    },
}
