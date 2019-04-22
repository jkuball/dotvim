let b:shebang = "#!/usr/bin/env python3\r# -*- coding: utf-8 -*-"

let b:linter = "pylint"

setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4

if executable('python3')
  let &path = &path . ',' . system("python3 -c \"from distutils.sysconfig import get_python_lib; print(get_python_lib(), end='')\"") . '/'
endif

set suffixesadd+=.py
set suffixesadd+=/__init__.py " for modules
