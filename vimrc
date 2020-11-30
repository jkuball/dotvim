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

" Colors
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'

" Essential tpope plugins
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" Other vim-only plugins
Plug 'markonm/traces.vim'
Plug 'justinmk/vim-dirvish'

" Toolkit plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vimwiki/vimwiki'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Language Aware Tools:
"" Using vim-lsp for language server completion features
"" and ale for linting and fixing, which I don't like
Plug 'prabirshrestha/vim-lsp'
Plug 'dense-analysis/ale'

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

" Set the insert mode cursor correctly
if $TERM_PROGRAM =~# 'iTerm'
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Configure vim-slime to use the terminal
let g:slime_target = 'vimterminal'
let g:slime_vimterminal_cmd = 'ipython'
let g:slime_python_ipython = 1
let g:slime_vimterminal_config = { 'term_name': 'Slime.vim', 'vertical': 1, 'term_finish': 'close' }
let g:slime_cell_delimiter = '# === #'
nmap <leader><c-c><c-c> <Plug>SlimeSendCell
nnoremap <leader><c-c>O O# === #<cr><esc>
nnoremap <leader><c-c>o o<cr># === #<esc>

" the :Redir command from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, rng, start, end)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~? '^!'
    let cmd = a:cmd =~? ' %'
          \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
          \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(cmd . ' <<< $' . cleaned_lines)
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

" TODO supply -bang to remove the current autocmd
" TODO allow multiple files
function GhettoOnSaved(args)
  augroup on_saved
    au!
    exe "autocmd BufWritePost " . expand("%") . " SlimeSend1 " . substitute(a:args, '%', {m -> expand('%')}, 'g')
  augroup END
endfunction
command! -complete=shellcmd -bang -nargs=* OnSaved call GhettoOnSaved("<args>")

" Configure FZF
nnoremap <c-p> :Files<cr>

" Set custom status line
set statusline=%(%q%h%r\ %)%t\ %y%m
set statusline+=%= " everything below this is right justified (for plugins)

" Configure vimwiki
"" Fix shadowing of Vinegars dash mapping which I prefer
nnoremap _ <Plug>VimwikiRemoveHeaderLevel

" Configure LSP
let g:lsp_diagnostics_enabled = 0
runtime! language_servers.vim
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal tagfunc=lsp#tagfunc
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f6> <plug>(lsp-rename)
  nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

function! LspStatusline()
  let servers = lsp#get_whitelisted_servers()
  if len(servers)
    let server = servers[0] " TODO use all servers
    let status = lsp#get_server_status(server)
    return printf(' [%s: %s]', server, status)
  endif
  return ''
endfunction
set statusline+=%(%{LspStatusline()}%)

" Configure ALE
nnoremap Q :ALEFix<cr>
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \ 'python': ['pyright', 'prospector'],
      \ 'rust': ['rustc', 'cargo'],
      \ 'tex': ['chktex'],
      \ 'vim': ['vint'],
      \ }
let g:ale_fixers = {
      \ 'python': ['isort', 'black'],
      \ 'rust': ['rustfmt'],
      \ 'yaml': ['prettier'],
      \ '*': ['trim_whitespace', 'remove_trailing_lines'],
      \ }
let g:ale_python_isort_options='--trailing-comma --multi-line 3 --line-width 116'
let g:ale_python_black_options='--line-length 116'
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '' : printf(
  \   ' [%dW %dE]',
  \   all_non_errors,
  \   all_errors
  \)
endfunction
set statusline+=%(%{LinterStatus()}%)

" Configure gitgutter
function! GitGutterStatus()
  let [a, m, r] = GitGutterGetHunkSummary()
  if (a + m + r) > 0
    return printf(' [+%d ~%d -%d]', a, m, r)
  endif
  return ''
endfunction
set statusline+=%(%{GitGutterStatus()}%)

" Configure fugitive
function! FugitiveStatus() abort
  let l:head = fugitive#head()
  if l:head ==# ''
    return ''
  endif
  return '[git:' . l:head . ']'
endfunction
set statusline+=%(%{FugitiveStatus()}%)
nnoremap <leader>g :tabedit % \| :G \| :only<cr>

" Configure obsession
set statusline+=%(%{ObsessionStatus('\ [session\ running]','')}%)
set sessionoptions-=buffers
