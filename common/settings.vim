" By default format with `formatprg` via Q
nnoremap Q gggqG

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

" Configure completion
set completeopt=menuone

" Configure folding
set foldlevelstart=99
 
" Set the insert mode cursor correctly
if $TERM_PROGRAM =~# 'iTerm'
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" If pyenv is installed, use pyenv's python3.
if executable('pyenv')
  let g:python3_host_prog = trim(system('pyenv root')) . '/shims/python3'
endif

" Sorting for specific text files
" This could be a 'formatexpr' somehow.
augroup sorting_Q
  autocmd!
  autocmd BufReadPost requirements.txt nnoremap <buffer> Q :sort<cr>
  autocmd BufReadPost spelling_wordlist.txt nnoremap <buffer> Q :sort<cr>
augroup END

" Set custom status line
set statusline=%(%q%h%r\ %)%t\ %y%m
set statusline+=%= " everything below this is right justified (for plugins)

" Configure fzf
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <space><c-p> :Rg<cr>

" Configure vim-test and vim-ultest
let test#strategy = "dispatch"
nnoremap <silent> <space>T :Ultest<cr>
nnoremap <silent> <space>t :UltestNearest<cr>
nnoremap <silent> <space>K :call ultest#output#jumpto()<cr>
nnoremap <silent> ]t :call ultest#positions#next()<cr>
nnoremap <silent> [t :call ultest#positions#prev()<cr>
let g:ultest_icons = 1
let g:ultest_max_threads = 4
let g:ultest_output_on_line = 0
let g:ultest_pass_sign = g:ultest_icons ? "✔" : "O"
let g:ultest_fail_sign = g:ultest_icons ? "✖" : "X"
let g:ultest_running_sign = g:ultest_icons ? "⏳" : ">"
let g:ultest_not_run_sign = g:ultest_icons ? "?" : "~"

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

" Configure dirvish
augroup dirvish_config
  autocmd!
  " File creation like netrw
  autocmd FileType dirvish
        \ nnoremap <buffer> % :edit %
augroup END
