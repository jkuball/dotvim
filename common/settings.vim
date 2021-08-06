" By default format with `formatprg` via Q
nnoremap Q gggqG<c-o><c-o>

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

" Set the insert mode cursor correctly
if $TERM_PROGRAM =~# 'iTerm'
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Configure FZF
nnoremap <c-p> :Files<cr>

" Set custom status line
set statusline=%(%q%h%r\ %)%t\ %y%m
set statusline+=%= " everything below this is right justified (for plugins)

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
