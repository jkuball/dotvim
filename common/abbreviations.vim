" Add abbreviations for things that I can't just get right.
" For some reason :Abolish isn't available at rc load time,
" so this augroup has to do.

augroup abolish
  au!
  autocmd FileType * Abolish {U,u}nkown {}nknown
  autocmd FileType * Abolish {P,p}ipline {}ipeline
augroup END

