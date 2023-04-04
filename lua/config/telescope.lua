local Module = {}

function Module.setup()
    local telescope = require("telescope")
    telescope.setup({
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
                    -- Copy emoji to the unnamed register
                    vim.fn.setreg('"', emoji)

                    -- When writing a commit message, just insert the selected emoji in the headline
                    if vim.fn.expand("%:t") == "COMMIT_EDITMSG" then
                        vim.cmd.normal("gg0P")
                    end
                end,
            },
        },
    })

    local gitmoji = telescope.load_extension("gitmoji")

    local opt = { silent = true, noremap = true }
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<C-p><C-p>", builtin.builtin, opt)
    vim.keymap.set("n", "<C-p>f", builtin.find_files, opt)
    vim.keymap.set("n", "<C-p>g", builtin.live_grep, opt)
    vim.keymap.set("n", "<C-p>*", builtin.grep_string, opt)
    vim.keymap.set("n", "<C-p>t", builtin.treesitter, opt)
    vim.keymap.set("n", "<C-p>c", builtin.commands, opt)
    vim.keymap.set("n", "<C-p>/", builtin.search_history, opt)
    vim.keymap.set("n", "<C-p>s", builtin.spell_suggest, opt)
    vim.keymap.set("n", "<C-p>b", builtin.buffers, opt)
    vim.keymap.set("n", "<C-p>d", builtin.diagnostics, opt)
    vim.keymap.set("n", "<C-p>e", gitmoji.gitmoji, opt)
    vim.keymap.set("n", "<C-p>l", builtin.lsp_document_symbols, opt)
    vim.keymap.set("n", "<C-p>L", builtin.lsp_workspace_symbols, opt)
end

return Module
