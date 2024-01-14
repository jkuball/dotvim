local Module = {}

-- NOTE: Most of my components here are just yanked from the cookbook, but then tailored a little bit.
-- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md

-- TODO: Maybe pack all components into their own file.
-- Find out how to make require("config.heirline") to load this file
-- and require("config.heirline.components") to load another.
-- Nearly every plugin does it like that, so it is possible -- but how?

-- NOTE: An idea would be to make a "🔴 REC" component if a recording is going on.
-- See :h reg_recording().
-- TODO: Look into:
-- - https://github.com/ecthelionvi/NeoComposer.nvim

function Module.setup()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local Align = { provider = "%=" }
    local Spacing = { provider = "  " }

    local DefaultStatusLine = {
        Module.ViMode(),
        Spacing,
        Module.FileNameBlock(conditions, utils),
        Spacing,
        Module.GitBlock(conditions, utils),
        Spacing,
        Module.HarpoonBlock(conditions, utils),
        Align,
        Module.VenvBlock(conditions, utils),
        Spacing,
        Module.FileEncodingBlock(conditions, utils),
        Spacing,
        Module.FileTypeBlock(conditions, utils),
    }

    local InactiveStatusLine = {
        condition = conditions.is_not_active,
        { provider = "   " },
        Spacing,
        Module.FileNameBlock(conditions, utils),
    }

    local highlightIfActive = function()
        if conditions.is_active() then
            return "StatusLine"
        else
            return "StatusLineNC"
        end
    end

    local StatusLines = {
        hl = highlightIfActive,
        -- the first statusline with no condition, or which condition returns true is used.
        -- think of it as a switch case with breaks to stop fallthrough.
        fallthrough = false,
        InactiveStatusLine,
        DefaultStatusLine,
    }

    local DefaultWinBar = {
        Module.NavicBlock(conditions, utils),
    }

    local InactiveWinBar = {
        condition = conditions.is_not_active,
        { provider = "" },
    }

    local WinBars = {
        hl = highlightIfActive,
        fallthrough = false,
        InactiveWinBar,
        DefaultWinBar,
    }

    local disable_winbar_cb = function(args)
        if args.event == "BufWinEnter" then
            -- If a client is active, enable the winbar.
            -- TODO: This is not a perfect solution, because the first time this is called,
            -- the client is not active yet and thus you have to open the file twice, which is quite meh.
            -- Maybe there is a way to use `vim.api.nvim_get_autocmds({ group = "lspconfig" })` to check
            -- if there is a client that *would* attach to the current buffer?
            local clients = vim.lsp.buf_get_clients()
            for _, _ in ipairs(clients) do
                return false
            end
        end
        return true
    end

    require("heirline").setup({
        statusline = StatusLines,
        winbar = WinBars,
        -- tabline = {},
        -- statuscolumn = {},
        opts = {
            disable_winbar_cb = disable_winbar_cb,
        },
    })

    -- -- Disable the global winbar but enable it for windows where a language server is attached.
    -- vim.opt.winbar = nil
    -- vim.api.nvim_create_autocmd('LspAttach', {
    --     group = vim.api.nvim_create_augroup('UserEnableWinbarPerWindow', {}),
    --     callback = function(event)
    --         if vim.lsp.get_client_by_id(event.data.client_id).name == 'copilot' then
    --             return
    --         end
    --
    --         vim.notify('client!')
    --
    --         vim.opt_local.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
    --     end,
    -- })
end

function Module.NavicBlock(_, _)
    local navic = require("nvim-navic")
    return {
        condition = function()
            return navic.is_available()
        end,
        provider = navic.get_location,
    }
end

function Module.GitBlock(_, _)
    return {
        condition = function()
            return "" ~= vim.fn.FugitiveGitDir()
        end,
        hl = { fg = "orange" },
        init = function(self)
            -- TODO: When to re-evaluate this?
            self.head = vim.fn.FugitiveHead()
        end,
        on_click = {
            name = "heirline_git_branch_picker",
            callback = function()
                require("telescope.builtin").git_branches()
            end,
        },
        {
            provider = function(self)
                return " " .. self.head
            end,
            hl = { bold = true },
        },
    }
end

function Module.HarpoonBlock(_, _)
    return {
        condition = function()
            return require("harpoon.mark").get_length() > 0
        end,
        hl = { fg = "orange" },
        on_click = {
            name = "heirline_harpoon_ui_toggle",
            callback = function()
                require("harpoon.ui").toggle_quick_menu()
            end,
        },
        {
            provider = function(self)
                return "⇀ " .. require("harpoon.mark").get_length()
            end,
            hl = { bold = true },
        },
    }
end

function Module.FileEncodingBlock(_, utils)
    return {
        provider = function()
            return (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
    }
end

function Module.FileTypeBlock(_, utils)
    return {
        provider = function()
            return vim.bo.filetype
        end,
        on_click = {
            name = "heirline_filetype_picker",
            callback = function()
                require("telescope.builtin").filetypes()
            end,
        },
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
    }
end

-- NOTE: Directly copied from the cookbook to get a grasp on how heirline works in a more complex example.
-- I have to fiddle around with the colors, that's for sure.
-- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md#crash-course-part-ii-filename-and-friends
function Module.FileNameBlock(conditions, utils)
    local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
    }

    -- We can now define some children separately and add them later
    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color =
                require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end,
    }

    local FileName = {
        provider = function(self)
            -- first, trim the pattern relative to the current directory. For other
            -- options, see :h filename-modifers
            local filename = vim.fn.fnamemodify(self.filename, ":.")
            if filename == "" then
                return "[No Name]"
            end
            -- now, if the filename would occupy more than 1/4th of the available
            -- space, we trim the file path to its initials
            -- See Flexible Components section below for dynamic truncation
            if not conditions.width_percent_below(#filename, 0.25) then
                filename = vim.fn.pathshorten(filename)
            end
            return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileFlags = {
        {
            condition = function()
                return vim.bo.modified
            end,
            provider = "[+]",
            hl = { fg = "green" },
        },
        {
            condition = function()
                return not vim.bo.modifiable or vim.bo.readonly
            end,
            provider = "", -- a lock symbol
            hl = { fg = "orange" },
        },
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component
    local FileNameModifer = {
        hl = function()
            if vim.bo.modified then
                -- use `force` because we need to override the child's hl foreground
                return { fg = "cyan", bold = true, force = true }
            end
        end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
        FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
    )

    return FileNameBlock
end

function Module.VenvBlock(conditions, utils)
    local activated_venv = function()
        local venv_name = require("venv-selector").get_active_venv()
        if venv_name ~= nil then
            return string.gsub(venv_name, ".*/pypoetry/virtualenvs/", "(poetry) ")
        else
            return "system"
        end
    end

    return {
        {
            condition = function()
                return require("venv-selector").get_active_venv() ~= nil
            end,
            provider = function()
                return "  " .. activated_venv()
            end,
            hl = { fg = utils.get_highlight("Type").fg, bold = true },
        },
        on_click = {
            callback = function()
                vim.cmd.VenvSelect()
            end,
            name = "heirline_statusline_venv_selector",
        },
    }
end

function Module.ViMode()
    -- TODO: I am not sure if I really need or even want the total information about the submodes vim is in.
    -- It might be a good idea to just pass in 0 to vim.fn.mode() and cleanup the static mode_names map.
    -- Also if seems to have a bug; if you go into a pending mode (like if you just type ! in mode) it flickers.

    return {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
            self.mode = vim.fn.mode(1) -- :h mode()
        end,
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
            mode_names = { -- change the strings if you like it vvvvverbose!
                n = "N",
                no = "N?",
                nov = "N?",
                noV = "N?",
                ["no\22"] = "N?",
                niI = "Ni",
                niR = "Nr",
                niV = "Nv",
                nt = "Nt",
                v = "V",
                vs = "Vs",
                V = "V_",
                Vs = "Vs",
                ["\22"] = "^V",
                ["\22s"] = "^V",
                s = "S",
                S = "S_",
                ["\19"] = "^S",
                i = "I",
                ic = "Ic",
                ix = "Ix",
                R = "R",
                Rc = "Rc",
                Rx = "Rx",
                Rv = "Rv",
                Rvc = "Rv",
                Rvx = "Rv",
                c = "C",
                cv = "Ex",
                r = "...",
                rm = "M",
                ["r?"] = "?",
                ["!"] = "!",
                t = "T",
            },
            mode_colors = {
                n = "green",
                i = "red",
                v = "blue",
                V = "blue",
                ["\22"] = "blue",
                c = "purple",
                s = "purple",
                S = "purple",
                ["\19"] = "purple",
                R = "orange",
                r = "orange",
                ["!"] = "red",
                t = "red",
            },
        },
        -- We can now access the value of mode() that, by now, would have been
        -- computed by `init()` and use it to index our strings dictionary.
        -- note how `static` fields become just regular attributes once the
        -- component is instantiated.
        provider = function(self)
            return "%-3( " .. self.mode_names[self.mode] .. " %)"
        end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
            local mode = self.mode:sub(1, 1) -- get only the first mode character
            return { bg = self.mode_colors[mode], bold = true }
        end,
        -- Re-evaluate the component only on ModeChanged event!
        -- Also allows the statusline to be re-evaluated when entering operator-pending mode
        update = {
            "ModeChanged",
            pattern = "*:*",
            callback = vim.schedule_wrap(function()
                vim.cmd("redrawstatus")
            end),
        },
    }
end

return Module
