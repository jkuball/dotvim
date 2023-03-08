local Module = {}

function Module.setup()
    -- These are all configuration options of doom-one,
    -- even if I am setting them to their default.
    vim.g.doom_one_enable_treesitter = true
    vim.g.doom_one_terminal_colors = true
    vim.g.doom_one_italic_comments = true
    vim.g.doom_one_transparent_background = false
    vim.g.doom_one_cursor_coloring = true
    vim.g.doom_one_telescope_highlights = true

    vim.cmd("colorscheme doom-one")
end

return Module
