local Module = {}

function Module.setup()
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    -- Move around in the matches like I am used to from FZF.
                    ["<C-j>"] = require("telescope.actions").move_selection_next,
                    ["<C-k>"] = require("telescope.actions").move_selection_previous,
                },
            },
        },
    })
end

return Module
