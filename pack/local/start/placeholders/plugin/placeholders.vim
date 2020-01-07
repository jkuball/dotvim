" placeholders.vim - Easy to use placeholders
" Maintainer:   Jonas Kuball <jkuball@tzi.de>
" Version:      0.1

let g:placeholder = '<!!>'
command! -nargs=1 Pnext call JumpToNextAndSelect(<f-args>, 0)
command! -nargs=1 Pprev call JumpToNextAndSelect(<f-args>, 1)
nnoremap <silent><expr> <leader>n ":Pnext " . g:placeholder . "<cr>"
nnoremap <silent><expr> <leader>p ":Pprev " . g:placeholder . "<cr>"
snoremap <silent><expr> <leader>n "<esc>:Pnext " . g:placeholder . "<cr>"
snoremap <silent><expr> <leader>p "<esc>:Pprev " . g:placeholder . "<cr>"
nnoremap <silent><expr> <leader>ip "a" . g:placeholder . "<esc>"
augroup Placeholder
  au!
  au syntax * highlight Placeholder ctermfg=26 ctermbg=255 guifg=#22863a guibg=#005cc5
  au syntax * call matchadd("Placeholder", g:placeholder)
augroup END

" Placeholder Helper
function! JumpToNextAndSelect(target, backwards)
  let l:flags = 'z'
  if a:backwards
    let l:flags = 'b' . 'z'
  endif
  if search(a:target, l:flags)
    exec 'normal v' . (strlen(a:target)-1) . "l\<c-g>"
  endif
endfunction
