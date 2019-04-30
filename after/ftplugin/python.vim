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

function! CompletePython(findstart, base)
  if a:findstart
    return -1
  endif
  python3 python3jedicomplete()
  return { 'words': l:matches }
endfunction
setlocal omnifunc=CompletePython

python3 << PYTHONEOF
import jedi, vim, os

def python3jedicomplete():
  # TODO make more dynamic or wait until jedi has fixed this behaviour.
  # Currently, jedi assumes sys.executable to point at the python
  # executable, but when python is embedded, it does point to the
  # embedding executable (in this case vim). To circumvent this we just
  # set it to the python path (really hardcoded for this system and
  # python version, but yeah.. I think it will be fixed soon.
  oldexec = sys.executable
  sys.executable = os.path.join(sys.prefix, "bin/python3.7")

  def clean_str(string):
      return string.replace("'", "''")

  try:
      line, column = vim.current.window.cursor
      script = jedi.Script(source="\n".join(vim.current.buffer), line=line, column=column)
      type_order = { v: i for i, v in
        enumerate([ "param", "statement", "module", "function", "class", "instance", "keyword" ])
      }

      completions = [ f"{{ 'abbr': '{clean_str(c.name_with_symbols)}', \
                           'info': '>>> {clean_str(c.description)}\n\n{clean_str(c.docstring())}', \
                           'kind': '[{clean_str(c.type)}]', \
                           'word': '{clean_str(c.complete)}' \
                        }}" for c in sorted(script.completions(), key=lambda x: type_order[x.type]) ]
      vim.command(f"let l:matches = [{','.join(completions)}]")

  except Exception as e:
      vim.command(f"echohl WarningMsg | echo 'Error in python jedi completion: {e}' | echohl None")
  finally:
      # Also restore sys.executable (See TODO above)
      sys.executable = oldexec
PYTHONEOF
