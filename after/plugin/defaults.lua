-- Jump between diagnostics marks (overridden by lspsaga plugin)
local common_map_options = { noremap = true, silent = true }
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, common_map_options)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, common_map_options)

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

-- Enable signcolumn and number for all files that I have a language server for.
-- The rationale for this is to reduce the flicker while the signs are reloaded.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserEnableSigncolumn", {}),
    callback = function()
        vim.cmd.setlocal("number")
        vim.cmd.setlocal("signcolumn=yes")
    end,
})
