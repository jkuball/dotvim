let b:shebang = "#!/usr/bin/env python3\r# -*- coding: utf-8 -*-"

let b:linter = "pylint"

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

