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
Plug 'simrat39/symbols-outline.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'marko-cerovac/material.nvim'

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

" toggle lsp outline
nnoremap <silent> <space>s :SymbolsOutline<CR>

lua << EOF
-- Configure Colorscheme
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
require('material').set()

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
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "rounded" }})<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "rounded" }})<CR>', opts)
  buf_set_keymap('n', 'Q', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
      border = "rounded"
    }
  )
end

local flags = { debounce_text_changes = 150 }

-- default configured servers here

local servers = { "pyright", "texlab" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = flags,
  }
end

-- servers with special needs below

nvim_lsp.yamlls.setup {
  on_attach = on_attach,
  flags = flags,
  filetypes = { "yaml", "yaml.docker-compose" }
}

nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  flags = flags,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 116
        },
      },
    },
  },
}
EOF
