let b:shebang = "#!/usr/bin/env python3\r# -*- coding: utf-8 -*-"

" If installed, use the language server
if executable('pyls')
  " Register LSP
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })

  " Disable Tag Generation
  let g:gutentags_enabled = 0

  " Jump to definition via tags
  nnoremap <buffer> <C-]> :LspDefinition<CR>
endif
