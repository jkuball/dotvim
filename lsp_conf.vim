" I really dislike obstrucive linters.
" Make sure to have flake8 configured correctly (in `~/.config/flake8`).
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_float_cursor = 1

" Clean up the augroup when sourcing this file
augroup LspInit
  au!
augroup END

" Register installed Language Servers

if executable('pyls')
  augroup LspInit
    au User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'pyls']},
          \ 'whitelist': ['python'],
          \ 'workspace_config': {
          \   'pyls': {
          \     'configurationSources': ['flake8']
          \   }
          \ }
          \ })
  augroup END
endif

if executable('typescript-language-server')
  augroup LspInit
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
  augroup LspInit
    au User lsp_setup call lsp#register_server({
          \ 'name': 'cssls',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
          \ 'whitelist': ['css', 'scss'],
          \ })
  augroup END
endif

if executable('html-languageserver')
  augroup LspInit
    au User lsp_setup call lsp#register_server({
          \ 'name': 'htmls',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},
          \ 'whitelist': ['html'],
          \ })
  augroup END
endif

" configuration of the lsp plugin

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  " The <plug>-mappings seem to be broken? TODO: Test later again
  " nnoremap <buffer> <c-]> <plug>(lsp-definition)
  " nnoremap <buffer> K <plug>(lsp-hover)
  setlocal formatexpr=lsp#ui#vim#document_range_format_sync()
  nnoremap <buffer> <c-]> :LspDefinition<cr>
  nnoremap <buffer> K :LspHover<cr>
  nnoremap <buffer> Q :LspDocumentFormat<cr>
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

function! LspStatusline()
  let servers = lsp#get_whitelisted_servers()
  if len(servers)
    let server = servers[0] " TODO use all servers
    let status = lsp#get_server_status(server)
    return printf('[%s: %s]', server, status)
  endif
  return ''
endfunction
