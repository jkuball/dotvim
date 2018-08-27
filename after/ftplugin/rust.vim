" If installed, use the language server
if executable('rls')
  " Register language client
  let g:LanguageClient_serverCommands.rust = ['rls']

  " Set up LSP Configuration
  EnableLSP

  " Disable ctags Tag Generation
  let g:gutentags_enabled = 0
endif

