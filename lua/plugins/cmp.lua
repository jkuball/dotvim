--- @type LazyPluginSpec[]
local specs = {{
	-- All cmp sources reside in their own file each,
	-- this file is just to setup cmp itself.
	--- @see readme lua/plugins/cmpsources/README.txt
	import = "plugins.cmpsources"
},
{
	"https://github.com/hrsh7th/nvim-cmp",
	branch = "main", -- no maintained tags
	event = "VeryLazy", -- should be loaded always
	config = function()
		local cmp = require('cmp')

		-- load all sources
		vim.cmd.doautocmd('User', 'load_cmp_sources')

		-- TODO: Sometimes copilot is a little too slow and then I select it by accident because I meant something from the lsp.
		--       Maybe there is some kind of solution for this?
		-- TODO: Note that I can't use nvim-cmp's feature of source groups because copilot always finds a way to complete something, and then the other groups are never used.
		--       So, all sources are used in the same group, hopefully this won't affect performance too much.
		--       An idea would be to have copilot in all groups and configure cmp somehow to jump to the next group if only copilot provides matches.
		local default_sources = {
			{ name = "copilot" },
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "buffer" },
		}

		-- NOTE: Since the configuration needs the require, I can't use lazy's 'opts'.
		--- @type cmp.ConfigSchema
		local opts = {
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end
			},
			formatting = {
				expandable_indicator = true, -- indicator for snippets etc
				fields = {"abbr", "kind", "menu"},
				format = require('lspkind').cmp_format({
					mode = 'symbol_text',
					maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
					ellipsis_char = '...',
					symbol_map = {
						Copilot = "",
					},
				})
			},
			mapping = { -- note that I'm not using 'cmp.mapping.preset' since there are way to many default mappings for my liking (even if I take a bunch from them)
				['<c-n>'] = {
					i = function()
						if cmp.visible() then
							return cmp.select_next_item({
								behavior = require("cmp.types").cmp.SelectBehavior.Insert
							})
						end
						cmp.complete()
					end,
				},
				['<c-p>'] = {
					i = function()
						if cmp.visible() then
							return cmp.select_prev_item({
								behavior = require("cmp.types").cmp.SelectBehavior.Insert
							})
						end
						cmp.complete()
					end,
				},
				['<cr>'] = {
					i = cmp.mapping.confirm({ select = false }),
				},
				['<c-c>'] = cmp.mapping.abort(),
				['<c-u>'] = cmp.mapping.scroll_docs(-vim.wo.scroll),
				['<c-d>'] = cmp.mapping.scroll_docs(vim.wo.scroll),
				['<c-Space>'] = cmp.mapping.complete(),
			},
			sources = cmp.config.sources(vim.deepcopy(default_sources)),
			experimental = {
				ghost_text = true,
			}
		}

		cmp.setup(opts)
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({ { name = "git" }, unpack(vim.deepcopy(default_sources)) })
		})
	end,
}}

return specs
