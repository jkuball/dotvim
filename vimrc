" My ~/.vim/vimrc
" Author: Jonas Kuball <jkuball@uni-bremen.de>

" Specify encodings, just in case.
set encoding=utf-8
scriptencoding utf-8

" Check for Plug.vim
if !filereadable(expand('~/.vim/autoload/plug.vim'))
  echom "vimrc not loaded, please install plug.vim"
  finish
endif

call plug#begin('~/.vim/pack')

" Essential tpope plugins
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" Language Server
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" Other plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dadbod'
Plug 'airblade/vim-gitgutter'
Plug 'vimwiki/vimwiki'
Plug 'jpalardy/vim-slime'

" Colorscheme
Plug 'rakr/vim-one'

call plug#end()

" Activate Colorscheme
set background=light
set termguicolors
colorscheme one

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

" Set the leaders
let mapleader = '\'
let maplocalleader = ','

" macOS specifics
if has('mac')
  set wildignore+=*.DS_Store

  " Set the insert mode cursor correctly
  if $TERM_PROGRAM =~# 'iTerm'
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

" Set custom status line
set statusline=%(%q%h%r\ %)%t\ %y%m
set statusline+=%= " everything below this is right justified (for plugins)

" Configure vim-slime to use the terminal
let g:slime_target = "vimterminal"
let g:slime_vimterminal_cmd = "ipython"
let g:slime_python_ipython = 1
let g:slime_vimterminal_config = { "term_name": "Slime.vim", "vertical": 1, "term_finish": "close" }
let g:slime_cell_delimiter = "# === #"
nmap <leader><c-c><c-c> <Plug>SlimeSendCell
nnoremap <leader><c-c>O O# === #<cr><esc>
nnoremap <leader><c-c>o o<cr># === #<esc>

" Configure vimwiki
"" Fix shadowing of Vinegars - which I prefer
nnoremap _ <Plug>VimwikiRemoveHeaderLevel

" Configure gitgutter
function! GitStatus()
  let [a, m, r] = GitGutterGetHunkSummary()
  if (a + m + r) > 0
    return printf('+%d ~%d -%d', a, m, r)
  endif
  return ""
endfunction
set statusline+=\ %([%{GitStatus()}]%)

" Configure fugitive
set statusline+=\ %([git:%{fugitive#head()}]%)
nnoremap <leader>g :tabedit % \| :G \| :only<cr>

" Configure obsession
set statusline+=%(%{ObsessionStatus('\ [session\ running]','')}%)
nnoremap <leader>g :tabedit % \| :G \| :only<cr>

" Configure LSP
runtime lsp_conf.vim

