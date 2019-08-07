let b:shebang = "#!/usr/bin/env python3\r# -*- coding: utf-8 -*-"

let b:linter = "pylint"

let g:surround_{char2nr('k')} = "\1Key from: \1[\"\r\"]"

setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4

" common typos
iabbr slef self
iabbr slfe self
iabbr selv self

setlocal nowrap

set suffixesadd+=.py
set suffixesadd+=/__init__.py " for modules
set suffixesadd+=/__main__.py " for modules

if !has("nvim")
  setlocal completeopt=menuone,preview,longest

  "" use jedi vim ..
  packadd jedi-vim
  " .. but disable automatic initalization ..
  let g:jedi#auto_initialization = 0
  " set the omnifunc
  setlocal omnifunc=jedi#completions
  " use the call signatures feature (after a second of holding the cursor)
  let g:jedi#show_call_signatures = 1
  let g:jedi#show_call_signatures_delay = 1000
  call jedi#configure_call_signatures()
  " .. and setup my own sensible mappings just for the useful features:
  nnoremap <silent> <buffer> <c-]> :call jedi#goto()<cr>
  nnoremap <silent> <buffer> K :call jedi#show_documentation()<cr>
endif

python3 << PYTHONEOF
import os
# TODO make more dynamic or wait until jedi has fixed this behaviour.
# Currently, jedi assumes sys.executable to point at the python
# executable, but when python is embedded, it does point to the
# embedding executable (in this case vim). To circumvent this we just
# set it to the python path (really hardcoded for this system and
# python version, but yeah.. I think it will be fixed soon.)
if "vim" in sys.executable:
  sys.executable = os.path.join(sys.prefix, "bin/python3")
PYTHONEOF
