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
        extensions = {
            gitmoji = {
                action = function(entry)
                    local emoji = entry.value.value
                    -- Copy emoji to the unnamed register.
                    vim.fn.setreg('"', emoji)
                end,
            },
        },
    })

    require("telescope").load_extension("gitmoji")
end

return Module
