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
Plug 'tpope/vim-abolish'

" Essential other plugins
Plug 'markonm/traces.vim'

" Toolkit plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vimwiki/vimwiki'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

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

" Wildignore DS_Store files on all systems
set wildignore+=*.DS_Store

" Format the full file with Q
nnoremap Q gggqG<c-o><c-o>

" Set the insert mode cursor correctly
if $TERM_PROGRAM =~# 'iTerm'
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
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

" Supply OnSaved command for fast development
function! SendKeys(args)
  let terms = filter(range(1, bufnr('$')), 'bufexists(v:val) && getbufvar(v:val, "&buftype") ==# "terminal"')
  if len(terms)
    let termbuf = terms[0]
  else
    let termbuf = term_start($SHELL)
  endif
  call term_sendkeys(termbuf, "clear\<cr>" . a:args . "\<cr>")
endfunction

function! OnSaved(args)
  if (!a:args)
    augroup OnSavedMiniPlugin
      au!
    augroup END
    return
  endif
  augroup OnSavedMiniPlugin
    au!
    exec "au BufWritePost " . expand("%:t") . " call SendKeys('" . expand(a:args) . "')"
  augroup END
  call SendKeys(a:args)
endfunction

" the :Redir command from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" TODO: complete=shellcmd for the first arg and after that complete=file
command! -complete=file -nargs=* OnSaved call OnSaved(<q-args>)

" Configure FZF
nnoremap <c-p> :Files<cr>

" Configure vimwiki
"" Fix shadowing of Vinegars - which I prefer
nnoremap _ <Plug>VimwikiRemoveHeaderLevel

" Configure gitgutter
function! GitGutterStatus()
  let [a, m, r] = GitGutterGetHunkSummary()
  if (a + m + r) > 0
    return printf('+%d ~%d -%d', a, m, r)
  endif
  return ""
endfunction
set statusline+=\ %([%{GitGutterStatus()}]%)

" Configure fugitive
set statusline+=\ %([git:\ %{fugitive#head()}]%)
nnoremap <leader>g :tabedit % \| :G \| :only<cr>

" Configure obsession
set statusline+=%(%{ObsessionStatus('\ [session\ running]','')}%)
set sessionoptions-=buffers
