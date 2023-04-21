-- TODO: Think about how to use harpoon terminals.
-- They are an interesting feature, but I am not sure how to include them in my workflow.

return {
    "ThePrimeagen/harpoon",
    opts = {
        projects = {
            -- Yes $HOME works
            ["$HOME/.config/nvim"] = {
                term = {
                    cmds = {
                        "echo 42",
                    },
                },
            },
        },
    },
    init = function()
        local bufopts = { noremap = true, silent = true }

        -- Manage Harpoon Marks
        vim.keymap.set("n", "<Leader>ha", require("harpoon.mark").add_file, bufopts)
        vim.keymap.set("n", "<Leader>hh", require("harpoon.ui").toggle_quick_menu, bufopts)

        -- Quickly switch between set marks
        vim.keymap.set("n", "]h", require("harpoon.ui").nav_next, bufopts)
        vim.keymap.set("n", "[h", require("harpoon.ui").nav_prev, bufopts)
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
}
