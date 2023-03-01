local Module = {}

function Module.open_nvim_tree(data)
    -- Open nvim-tree on opening a directory.
    -- For extending the logik, look at https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup

    local is_directory = vim.fn.isdirectory(data.file) == 1

    if not is_directory then
        return
    end

    require("nvim-tree.api").tree.open(data.file)
end

function Module.setup()
    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = Module.open_nvim_tree })

    vim.keymap.set("n", "-", require("nvim-tree.api").tree.open, {})

    require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = true,
        sort_by = "case_sensitive",
        renderer = {
            icons = {
                git_placement = "signcolumn",
            },
        },
    })
end

return Module
