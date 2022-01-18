" My ~/.vim/vimrc
" Author: Jonas Kuball <jkuball@uni-bremen.de>

" Specify encodings, just in case.
set encoding=utf-8
scriptencoding utf-8

" Check for Plug.vim
if !filereadable(expand('~/.vim/autoload/plug.vim'))
  echom 'vimrc not loaded, please install plug.vim'
  finish
endif

call plug#begin('~/.vim/pack')

source ~/.vim/common/plugins.vim

" Colors
Plug 'rakr/vim-one'

call plug#end()

source ~/.vim/common/settings.vim
source ~/.vim/common/abbreviations.vim
source ~/.vim/common/commands.vim

" Activate Colorscheme
set background=light
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

" Configure FZF
nnoremap <c-p> :Files<cr>

