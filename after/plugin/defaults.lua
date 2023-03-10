-- Enables 24-bit RGB color in the terminal
vim.opt.termguicolors = true

-- Jump between diagnostics marks
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
    callback = function()
        vim.cmd.checktime()
    end,
})
