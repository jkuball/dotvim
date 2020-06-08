" I hate linters.
" Make sure to have flake8 configured correctly (in `~/.config/flake8`).
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_float_cursor = 1

" Configure Language Servers
if executable('pyls') " TODO: Can this be moved to a filetype plugin
  augroup LspInit
    au!
    au User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \ 'workspace_config': {
          \   'pyls': {
          \     'configurationSources': ['flake8']
          \   }
          \ }
          \ })
  augroup END
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  " The <plug>-mappings seem to be broken? TODO: Test later again
  " nnoremap <buffer> <c-]> <plug>(lsp-definition)
  " nnoremap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <c-]> :LspDefinition<cr>
  nnoremap <buffer> K :LspHover<cr>
  nnoremap <buffer> Q :LspDocumentFormat<cr>
  setlocal formatexpr=lsp#ui#vim#document_range_format_sync()
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
