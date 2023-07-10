-- Look into:
-- - https://github.com/epwalsh/obsidian.nvim
-- - https://github.com/jubnzv/mdeval.nvim
-- - https://github.com/lukas-reineke/headlines.nvim

return {
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.api.nvim_call_function("mkdp#util#install", {})
        end,
        ft = "markdown",
    },
}
