-- IDEA: Do I want to include the number of harpooned files in my statusline?

return {
    "jkuball/harpoon", -- until https://github.com/ThePrimeagen/harpoon/pull/295 is approved
    branch = "feat/cmd-ui/resend",
    opts = {
        global_settings = {
            enter_on_sendcmd = true,
        },
    },
    config = function(_, opts)
        require("harpoon").setup(opts)

        local harpoon_ui = require("harpoon.ui")
        local harpoon_cmd_ui = require("harpoon.cmd-ui")
        local harpoon_mark = require("harpoon.mark")
        local harpoon_term = require("harpoon.term")
        local wk = require("which-key")

        local _nav_file = function(num)
            return function()
                harpoon_ui.nav_file(num)
            end
        end

        local _nav_term = function(num)
            return function()
                harpoon_term.gotoTerminal(num)
            end
        end

        local invisible = "which_key_ignore"

        wk.register({
            t = {
                name = "+term",
                t = { require("harpoon.cmd-ui").toggle_quick_menu, "Harpoon Cmd-Ui" },
                ["<CR>"] = { harpoon_cmd_ui.resend, "Send last selected Harpoon Command" },
                ["#"] = "Go to Harpoon Terminal (1-9)",
                ["1"] = { _nav_term(1), invisible },
                ["2"] = { _nav_term(2), invisible },
                ["3"] = { _nav_term(3), invisible },
                ["4"] = { _nav_term(4), invisible },
                ["5"] = { _nav_term(5), invisible },
                ["6"] = { _nav_term(6), invisible },
                ["7"] = { _nav_term(7), invisible },
                ["8"] = { _nav_term(8), invisible },
                ["9"] = { _nav_term(9), invisible },
            },
            h = {
                name = "+harpoon",
                h = { harpoon_ui.toggle_quick_menu, "Toggle Quick Menu" },
                a = { harpoon_mark.add_file, "Add current file" },
                n = { harpoon_mark.nav_next, "Go to next file" },
                p = { harpoon_mark.nav_prev, "Go to previous file" },
                ["#"] = "Go to Harpooned File (1-9)",
                ["1"] = { _nav_file(1), invisible },
                ["2"] = { _nav_file(2), invisible },
                ["3"] = { _nav_file(3), invisible },
                ["4"] = { _nav_file(4), invisible },
                ["5"] = { _nav_file(5), invisible },
                ["6"] = { _nav_file(6), invisible },
                ["7"] = { _nav_file(7), invisible },
                ["8"] = { _nav_file(8), invisible },
                ["9"] = { _nav_file(9), invisible },
            },
            ["<CR>"] = { harpoon_cmd_ui.resend, "Send last selected Harpoon Command" },
            ["#"] = "Go to Harpooned File (1-9)",
            ["1"] = { _nav_file(1), invisible },
            ["2"] = { _nav_file(2), invisible },
            ["3"] = { _nav_file(3), invisible },
            ["4"] = { _nav_file(4), invisible },
            ["5"] = { _nav_file(5), invisible },
            ["6"] = { _nav_file(6), invisible },
            ["7"] = { _nav_file(7), invisible },
            ["8"] = { _nav_file(8), invisible },
            ["9"] = { _nav_file(9), invisible },
        }, { prefix = "<Leader>" })

        wk.register({
            ["[h"] = { harpoon_ui.nav_prev, "Next Harpooned File" },
            ["]h"] = { harpoon_ui.nav_next, "Previous Harpooned File" },
        })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
}
