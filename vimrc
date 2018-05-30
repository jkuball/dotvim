" My ~/.vim/vimrc
" Author: Jonas Kuball <jkuball@tzi.de>

" Firstly, load sensible.vim to have sane defaults set
packadd vim-sensible

" Allow easy :argdo modifications etc.
set hidden

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

" Set spelling languages
set spelllang=de,en_us

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

" Align the paragraph with the top of the screen
nnoremap gzz {jzt``

" Re-generate helptags
command! Helptags helptags ALL

" Map the build process to mnemonic keys (make, build, run).
" They might be overwritten in specific filetypes depending on their context.
" By default, all should just call vim-dispatches :Make command since it's the
" most versatile (and for the most filetypes I just have to set &makeprg).
nnoremap <leader>m :Make<cr>
nnoremap <leader>b :Make<cr>
nnoremap <leader>r :Make<cr>
nnoremap <c-m> :Make<cr>

" Just a small convenience thing for myself that might be enough
" to make into a proper plugin. I noticed a pattern in my workflow
" where a simple :Make is not enough, so this helps with non-standard
" build commands. For instance, when in a python script, you can call
" `:ActivateTermBuild python3 myscript.py --some --arguments 42` to open
" a terminal and setup <c-m> to send the previously given command to it.
" It only starts a new terminal if one is not already present, so you can use
" it to update the build command.
function OpenTermForBuild(buildcommand)
  if bufnr('!' . &shell) < 0
    call term_start(&shell, { 'term_rows': 10 })
    normal ``
  endif
  exec "nnoremap <c-m> :call term_sendkeys(bufnr('!' . &shell), \"\\<lt>c-l>" . a:buildcommand . "\\<lt>cr>\")<cr>``"
endfunction
command! -nargs=1 ActivateTermBuild call OpenTermForBuild(<q-args>)

" Supply the :Shebang command which inserts the contents of the
" variable b:shebang. It needs to be set for each filetype in
" after/ftplugin/filetype.vim
command! -nargs=0 Shebang if exists("b:shebang") |
      \ exec 'normal!ggO' . b:shebang |
      \ else |
      \ echohl WarningMsg |
      \ echo "No shebang specified for " . expand(&ft) |
      \ echohl None |
      \ endif

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
