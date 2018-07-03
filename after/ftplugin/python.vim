let b:shebang = "#!/usr/bin/env python3\r# -*- coding: utf-8 -*-"

" If installed, use the language server
if executable('pyls')
  " Register language client
  let g:LanguageClient_serverCommands.python = ['pyls']

  " Set up LSP Configuration
  EnableLSP

  " Disable ctags Tag Generation
  let g:gutentags_enabled = 0
endif
