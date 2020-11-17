" Clear the LSP augroup and then dynamically add
" registering servers if they are installed

augroup LSP
  au!
augroup END

if executable('pyls')
  augroup LSP
    au User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'allowlist': ['python'],
          \ })
  augroup END
endif

if executable('rls')
  augroup LSP
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
  augroup END
endif

if executable('typescript-language-server')
  augroup LSP
    au User lsp_setup call lsp#register_server({
          \ 'name': 'tsls',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
          \ 'root_uri': {
          \   server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))
          \ }
          \ })
  augroup END
endif

if executable('css-languageserver')
  augroup LSP
    au User lsp_setup call lsp#register_server({
          \ 'name': 'cssls',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
          \ 'whitelist': ['css', 'scss'],
          \ })
  augroup END
endif

if executable('html-languageserver')
  augroup LSP
    au User lsp_setup call lsp#register_server({
          \ 'name': 'htmls',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},
          \ 'whitelist': ['html'],
          \ })
  augroup END
endif

if executable('texlab')
  augroup LSP
    au User lsp_setup call lsp#register_server({
          \ 'name': 'texlab',
          \ 'cmd': {server_info->['texlab']},
          \ 'whitelist': ['tex'],
          \ })
  augroup END
endif
