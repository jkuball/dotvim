-- NOTE: Update to harpoon 2 when it is stable (https://github.com/ThePrimeagen/harpoon).
return {
    "ThePrimeagen/harpoon",
    branch = "master",
    event = "VeryLazy",
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
            return {
                function()
                    harpoon_ui.nav_file(num)
                end,
                "which_key_ignore",
            }
        end

        local _nav_term = function(num)
            return {
                function()
                    harpoon_term.gotoTerminal(num)
                end,
                "which_key_ignore",
            }
        end

        wk.register({
            t = {
                t = { harpoon_cmd_ui.toggle_quick_menu, "Harpoon Cmd-Ui" },
                ["#"] = "Go to Harpoon Terminal (1-9)",
                ["1"] = _nav_term(1),
                ["2"] = _nav_term(2),
                ["3"] = _nav_term(3),
                ["4"] = _nav_term(4),
                ["5"] = _nav_term(5),
                ["6"] = _nav_term(6),
                ["7"] = _nav_term(7),
                ["8"] = _nav_term(8),
                ["9"] = _nav_term(9),
            },
            h = {
                h = { harpoon_ui.toggle_quick_menu, "Toggle Quick Menu" },
                a = { harpoon_mark.add_file, "Add current file" },
                n = { harpoon_mark.nav_next, "Go to next file" },
                p = { harpoon_mark.nav_prev, "Go to previous file" },
                ["#"] = "Go to Harpooned File (1-9)",
                ["1"] = _nav_file(1),
                ["2"] = _nav_file(2),
                ["3"] = _nav_file(3),
                ["4"] = _nav_file(4),
                ["5"] = _nav_file(5),
                ["6"] = _nav_file(6),
                ["7"] = _nav_file(7),
                ["8"] = _nav_file(8),
                ["9"] = _nav_file(9),
            },
            ["#"] = "Go to Harpooned File (1-9)",
            ["1"] = _nav_file(1),
            ["2"] = _nav_file(2),
            ["3"] = _nav_file(3),
            ["4"] = _nav_file(4),
            ["5"] = _nav_file(5),
            ["6"] = _nav_file(6),
            ["7"] = _nav_file(7),
            ["8"] = _nav_file(8),
            ["9"] = _nav_file(9),
        }, { prefix = "<Leader>" })

        wk.register({
            ["[h"] = { harpoon_ui.nav_prev, "Next Harpooned File" },
            ["]h"] = { harpoon_ui.nav_next, "Previous Harpooned File" },
        })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
}
