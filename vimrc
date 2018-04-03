" My ~/.vim/vimrc
" Author: Jonas Kuball <jkuball@tzi.de>

" Firstly, load sensible.vim
packadd vim-sensible

" Default indentation, might be overwritten for specific filetypes
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Never lose anything
set backup
set undofile
set directory=$HOME/.vim/.swapfiles//
set backupdir=$HOME/.vim/.backupfiles//
set undodir=$HOME/.vim/.undofiles//

" Set leader
let mapleader="\<Space>"
let maplocalleader="\<Space>"

" No mouse in insert mode
set mouse=nv

" Line numbering
set nu

" No ex mode
map Q gq

" Convenience Mappings
nnoremap ZZ :wq<cr>
nnoremap XX :q!<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

"" Better refactoring/multiple replacements. Thanks to
"" kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"
nnoremap cn *''cgn
nnoremap cN *''cgN
vnoremap <expr> cn g:mc . "''cgn"
vnoremap <expr> cN g:mc . "''cgN"

" Re-generate helptags
command! Helptags helptags ALL

" Set custom status line
set statusline=%(%q%h%r\ %)%t\ %y%m
set statusline+=%= " everything below this is right justified (mostly for plugins)

" If ctags is installed, use vim-gutentags.
if executable("ctags")
  packadd vim-gutentags
  set statusline+=%{gutentags#statusline('[','\ ♺\ ]')}
endif

" If git is installed, use vim-fugitive.
if executable("git")
  packadd vim-fugitive
  set statusline+=%([git:%{fugitive#head()}]%)
endif
