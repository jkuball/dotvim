" linting.vim - Easy and simple linting for files
" Maintainer:   Jonas Kuball <jkuball@tzi.de>
" Version:      0.1

" Supply the :Lint command which fills the quickfix list with the output
" of the shell program that's set in the variable b:linter. It needs to
" be set for each filetype in after/ftplugin/filetype.vim
"" TODO if needed, custom errorformat, read from stdin or not, etc
function! Lint(lintcmd)
  let l:linter = a:lintcmd
  if strlen(l:linter) <= 0
    if !exists('b:linter')
      echohl WarningMsg | echo 'No linter specified for ' . expand(&ft) | echohl None
      return
    else
      let l:linter = b:linter
    endif
  endif
  if !executable(split(l:linter)[0])
    echohl WarningMsg | echo 'No such executable ' . l:linter | echohl None
    return
  endif
  cgetexpr system(l:linter . ' ' . expand('%'))
  if len(getqflist()) > 0
    copen
  else
    echo 'Linting done, output empty.'
  endif
endfunction
command! -nargs=? -complete=shellcmd Lint call Lint(<q-args>)
nnoremap <leader>l :Lint<cr>

