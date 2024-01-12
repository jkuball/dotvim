-- Bootstrap lazy.nvim 💤
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Enables 24-bit RGB color in the terminal
vim.opt.termguicolors = true

-- Setting both leader keys.
-- NOTE: I might revisit this in the future, but I am used to the Spacebar right now (and I think it is a good key for that).
-- For now, the localleader will be something explicitly different than the normal Leader, just to see how often I use/need it.
-- I feel like it won't be that often -- unless I decide that I want LSP functionality behind that, which might be reasonable.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Setting static configuration for Neovide.
if vim.g.neovide then
    vim.o.guifont = "FiraCode Nerd Font Mono:h10"
end

-- Automatically loads all plugins defined in `lua/plugins/*.lua`.
require("lazy").setup({ { import = "plugins" } }, { change_detection = { notify = false } })
