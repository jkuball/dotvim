" My ~/.vim/vimrc
" Author: Jonas Kuball <jkuball@tzi.de>

" Specify encodings, just in case.
set encoding=utf-8
scriptencoding utf-8

" Check for 
if !filereadable(expand('~/.vim/autoload/plug.vim'))
  echom "vimrc not loaded, please install plug.vim"
  finish
endif

call plug#begin('~/.vim/pack')

" Essential tpope plugins
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" Language Server
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

call plug#end()

" Never lose anything
for type in ['swap', 'backup', 'undo']
 if !isdirectory(expand('$HOME/.vim/.' . type . 'files//'))
   call mkdir(expand('$HOME/.vim/.' . type . 'files//'))
 endif
endfor
set backup
set undofile
set directory=$HOME/.vim/.swapfiles//
set backupdir=$HOME/.vim/.backupfiles//
set undodir=$HOME/.vim/.undofiles//

" Use 2 spaces as default indentation
set expandtab
set tabstop=2
set shiftwidth=2

" Convenience settings
set hidden
set mouse=a

" Open windows more naturally for me
set splitbelow
set splitright

" Configure Language Servers
if executable('pyls') " TODO: Can this be moved to a filetype plugin
  au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {
        \   'pyls': {
        \     'configurationSources': ['flake8']
        \   }
        \ }
        \ })
endif

" I hate linters.
" Make sure to have flake8 configured correctly (in `~/.config/flake8`).
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_float_cursor = 1

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  " The <plug>-mappings seem to be broken? TODO: Test later again
  " nnoremap <buffer> <c-]> <plug>(lsp-definition)
  " nnoremap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <c-]> :LspDefinition<cr>
  nnoremap <buffer> K :LspHover<cr>
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
