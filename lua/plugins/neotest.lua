return {
    {
        "nvim-neotest/neotest",
        event = "BufEnter */tests/*.py",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
        },
        config = function()
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-python"),
                },
            })

            local wk = require("which-key")

            wk.register({
                name = "+test",
                t = { neotest.run.run, "Run nearest Test" },
                T = {
                    function()
                        neotest.run.run(vim.fn.expand("%"))
                    end,
                    "Run all Tests in File",
                },
                x = { neotest.run.stop, "Stop nearest Test" },
                a = { neotest.run.attach, "Attach to nearest Test" },
                o = {
                    function()
                        neotest.output.open({ enter = true })
                    end,
                    "Open nearest Test",
                },
                s = { neotest.summary.toggle, "Toggle summary" },
            }, { prefix = "<Localleader>t" })

            wk.register({
                ["[t"] = { neotest.jump.prev, "Next Test" },
                ["]t"] = { neotest.jump.next, "Previous Test" },
                ["[f"] = {
                    function()
                        neotest.jump.prev({ status = "failed" })
                    end,
                    "Next failed Test",
                },
                ["]f"] = {
                    function()
                        neotest.jump.next({ status = "failed" })
                    end,
                    "Previous failed Test",
                },
            })
        end,
    },
}
