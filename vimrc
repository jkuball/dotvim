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

" Trailing whitespaces with 'list'
set list
set listchars=trail:~

