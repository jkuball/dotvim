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

-- Setting both leader keys.
-- NOTE: I might revisit this in the future, but I am used to the Spacebar right now (and I think it is a good key for that).
-- For now, the localleader will be something explicitly different than the normal Leader, just to see how often I use/need it.
-- I feel like it won't be that often -- unless I decide that I want LSP functionality behind that, which might be reasonable.
vim.g.mapleader = " "
vim.g.maplocalleader = ","
