--- @type LazyPluginSpec[]
local specs = {{
    "williamboman/mason.nvim",
    -- NOTE: They advise against lazy loading this plugin, but I am doing it anyway. As soon as something breaks, just make it `lazy = false`.
    cmd = {"Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog"},
    opts = {},
    version = "^1.10.0",
}}

return specs
