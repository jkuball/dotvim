local wk = require("which-key")

-- Jump between diagnostics marks
wk.register({
    ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
    ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
})

-- Other diagnostics mappings
wk.register({
    d = {
        name = "+diagnostics",
        l = { vim.diagnostic.open_float, "Show Line Diagnostics" },
    },
}, { prefix = "<Leader>" })

-- Open splits in a more natural order (for me)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Only show a completion menu, don't open a preview window
vim.opt.completeopt = "menuone"

-- Enable undo persistence
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undofile = true

-- Automatically reload files from disk if there are no local changes
vim.opt.autoread = true
vim.opt.updatetime = 300
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
    group = vim.api.nvim_create_augroup("UserAutoChecktime", {}),
    callback = function()
        local buf = vim.api.nvim_win_get_buf(0)
        local name = vim.api.nvim_buf_get_name(buf)
        -- Only call :checktime when the file attached to the buffer exists.
        -- This is needed because it throws an error when you are in the vim command-line window (q:).
        if vim.fn.filereadable(vim.fn.expand(name)) == 1 then
            vim.cmd.checktime()
        end
    end,
})

-- Always show signcolumn in files where diagnostics came up.
-- The rationale for this is to reduce the flicker while the signs are reloaded.
vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = vim.api.nvim_create_augroup("UserEnableSigncolumn", {}),
    callback = function()
        vim.cmd.setlocal("signcolumn=yes")
    end,
})

-- Dispatch Mappings
wk.register({
    ["<CR>"] = { "<cmd>Start<cr>", ":Start" },
}, { prefix = "<Leader>" })
