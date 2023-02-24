" My ~/.config/nvim/init.vim
" Author: Jonas Kuball <jkuball@uni-bremen.de>

" Specify encodings, just in case.
set encoding=utf-8
scriptencoding utf-8

" Check for Plug.vim
if !filereadable(stdpath('data') . '/site/autoload/plug.vim')
  echom 'init.vim not loaded, please install plug.vim'
  finish
endif

call plug#begin(stdpath('data') . '/plugged')

" Load vim/nvim common plugins
exec 'source ' . stdpath('config') . '/common/plugins.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'creativenull/diagnosticls-configs-nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'marko-cerovac/material.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'simrat39/rust-tools.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-lua/plenary.nvim'

call plug#end()

" Load vim/nvim common settings
exec 'source ' . stdpath('config') . '/common/settings.vim'
exec 'source ' . stdpath('config') . '/common/abbreviations.vim'
exec 'source ' . stdpath('config') . '/common/commands.vim'

" Never lose anything
call mkdir(stdpath('data') . '/backupfiles', 'p')
exec 'set backupdir=' . stdpath('data') . '/backupfiles'
set backup
set undofile

" configure tree-sitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "phpdoc" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}
EOF

" configure colors
lua << EOF
vim.g.material_style = 'lighter'
vim.g.material_italic_comments = true
vim.g.material_italic_keywords = true
vim.g.material_italic_functions = false
vim.g.material_italic_variables = false
vim.g.material_contrast = false
vim.g.material_borders = true
vim.g.material_disable_background = false
vim.g.material_custom_colors = {
  highlight = "#F6A434", -- low contrast lighter theme yellow
  border = "#91B859", -- low contrast lighter theme green
}
vim.cmd [[ colorscheme material ]]

-- set inactive statusline backgrounds to not be invisible
vim.cmd [[ highlight StatusLineNC guifg=#546E7A guibg=#E7E7E8 ]]
vim.cmd [[ highlight StatusLineTermNC guifg=#94A7B0 guibg=#E7E7E8 ]]

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Set omnifunc
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set mappings
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ popup_opts = { border = "rounded" }})<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = "rounded" }})<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "rounded" }})<CR>', opts)
  buf_set_keymap('n', 'Q', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
      border = "rounded"
    }
  )
end

local on_attach_no_format = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
  on_attach(client, bufnr)
end

local flags = { debounce_text_changes = 150 }

-- default configured servers here

local servers = { "dockerls", "esbonio", "jsonls", "texlab", "tsserver", "vimls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = flags,
  }
end

-- servers with special needs below

nvim_lsp.taplo.setup {
  on_attach = on_attach,
  flags = flags,
  filetypes = { "toml", "config" },
  root_dir = nvim_lsp.util.root_pattern("*.toml", ".git", "Pipfile"),
}

nvim_lsp.yamlls.setup {
  on_attach = on_attach,
  flags = flags,
  filetypes = { "yaml", "yaml.docker-compose" },
  settings = {
    yaml = {
      customTags = {
        "!type scalar",
        "!ref scalar",
      },
    },
  },
}

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  flags = flags,
  settings = {
    python = {
      analysis = "strict",
    },
  },
}

nvim_lsp.pylsp.setup {
  on_attach = on_attach_no_format,
  flags = flags,
  settings = {
  },
}

-- extra special needs: LSPs that have their own init function

local dlsconfig = require 'diagnosticls-configs'
local black = require 'diagnosticls-configs.formatters.black'
local isort = require 'diagnosticls-configs.formatters.isort'
local autoimport = require 'diagnosticls-configs.formatters.autoimport'

dlsconfig.init {
  on_attach = on_attach,
}

dlsconfig.setup {
  ['python'] = {
    formatter = { isort, black } --, autoimport }
  },
}

require('rust-tools').setup({
  server = {
    cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
    on_attach = on_attach,
    flags = flags,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      },
    },
  },
})
EOF
