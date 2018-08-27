" If installed, use the language server
if executable('/Users/jonas/cquery/bin/cquery')
  " Register language client
  let g:LanguageClient_serverCommands.cpp = ['/Users/jonas/cquery/bin/cquery', '--log-file=/tmp/cquery.log', '--init={"cacheDirectory":"/tmp/cqueryCache/"}']

  " Set up LSP Configuration
  EnableLSP

  " Disable ctags Tag Generation
  let g:gutentags_enabled = 0
endif
