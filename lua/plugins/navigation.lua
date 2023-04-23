-- TODO: Think about how to use harpoon terminals.
-- They are an interesting feature, but I am not sure how to include them in my workflow.

-- Idea: Do I want to include the number of harpooned files in my statusline?

return {
    "ThePrimeagen/harpoon",
    opts = {},
    init = function()
        local harpoon_ui = require("harpoon.ui")
        local harpoon_mark = require("harpoon.mark")

        local bufopts = { noremap = true, silent = true }

        -- Manage Harpoon Marks
        vim.keymap.set("n", "<Leader>ha", harpoon_mark.add_file, bufopts)
        vim.keymap.set("n", "<Leader>hm", harpoon_mark.add_file, bufopts)
        vim.keymap.set("n", "<Leader>hh", harpoon_ui.toggle_quick_menu, bufopts)

        -- Quickly switch between set marks
        vim.keymap.set("n", "<Leader>hn", harpoon_ui.nav_next, bufopts)
        vim.keymap.set("n", "]h", harpoon_ui.nav_next, bufopts)
        vim.keymap.set("n", "<Leader>hp", harpoon_ui.nav_prev, bufopts)
        vim.keymap.set("n", "[h", harpoon_ui.nav_prev, bufopts)
        local _nav_file = function(num)
            return function()
                harpoon_ui.nav_file(num)
            end
        end
        for c = 1, 9 do
            vim.keymap.set("n", "<Leader>" .. c, _nav_file(c), bufopts)
        end
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
}
