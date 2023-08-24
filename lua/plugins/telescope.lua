return {
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.x",
        event = "VeryLazy",
        config = function()
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

            local gitmoji = require("telescope").load_extension("gitmoji")

            local wk = require("which-key")
            local builtin = require("telescope.builtin")
            wk.register({
                ["<C-p>"] = { builtin.builtin, "Finders / Pickers" },
                f = { builtin.find_files, "Find files" },
                g = { builtin.live_grep, "Live grep" },
                ["*"] = { builtin.grep_string, "Live Grep for <cword>" },
                t = { builtin.treesitter, "Treesitter node" },
                c = { builtin.commands, "Vim command" },
                ["/"] = { builtin.search_history, "Search history" },
                s = { builtin.spell_suggest, "Spell suggestion" },
                b = { builtin.buffers, "Buffers" },
                d = { builtin.diagnostics, "Diagnostics" },
                e = { gitmoji.gitmoji, "Gitmoji" },
                l = { builtin.lsp_document_symbols, "Lsp Document Symbols" },
                L = { builtin.lsp_workspace_symbols, "Lsp Workspace Symbols" },
            }, { prefix = "<Leader>f" })
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "olacin/telescope-gitmoji.nvim",
        },
    },
}
