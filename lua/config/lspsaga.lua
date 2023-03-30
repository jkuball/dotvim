local Module = {}

function Module.setup()
    require("lspsaga").setup({
        lightbulb = {
            sign = false,
            virtual_text = true,
        },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspsagaConfig", {}),
        callback = function(event)
            local bufopts = { noremap = true, silent = true, buffer = event.buf }

            -- Use LSP Code Actions.
            vim.keymap.set("n", "<Leader>ca", "<cmd>Lspsaga code_action<cr>", bufopts)

            -- Rename symbols.
            vim.keymap.set("n", "<F2>", "<cmd>Lspsaga rename ++project<cr>", bufopts)
            vim.keymap.set("n", "<Leader>rn", "<cmd>Lspsaga rename ++project<cr>", bufopts)

            -- Goto definition.
            vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<cr>", bufopts)

            -- Inspect the symbol under the cursor. Replace 'keywordprg'.
            vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", bufopts)
        end,
    })
end

return Module
