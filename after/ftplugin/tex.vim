" Set default latex compiler
set makeprg=latexmk\ -pdf

" Semantic omnicompletion for my latex files.
"
" When cursor is on cite{
"   Scans all **/*.bib files for lines that match this pattern: @TYPE{NAME,
"   (NAME will be completed and TYPE could be anything containing alphanumerical characters and colons)
"   Also, every entry needs to have a title defined.
"
" When cursor is on ref{
"   Scans all **/*.tex files for \label{}'s.
"
" Note, that it doesn't look for the backslash in \cite and \ref. That means,
" it works on my usual defined commands like \secref{} etc.
"
function! CompleteTex(findstart, base)
  let line = getline(".")
  let start = col(".") - 1

  if a:findstart

    while start > 0 && line[start - 1] =~ "[0-9A-Za-z:]"
      let start -= 1
    endwhile

    if line[start - 5:start] =~ "cite{" || line[start - 4:start] =~ "ref{"
      return start
    endif

    return -3
    " theoretically, this should return -1 to throw an error and stop
    " completing, but it seems like that doesn't work like documented.

  else

    let completion = { 'words': [], 'refresh': 'always' }

    " We need citation completion.
    if line[start - 5:start] =~ "cite{"
      for bibfile in glob('**/*.bib', 0, 1)
        let item = {}
        for line in readfile(bibfile)
          if !has_key(item, 'word')
            let matched = matchlist(line, '@.\+{\(' . a:base . '[0-9a-zA-Z:]\+\),')
            if len(matched) > 1
              let item.word = get(matched, 1)
              let item.abbr = '[' . item.word . ']'
            endif
          else
            let matched = matchlist(line, '[Tt][Ii][Tt][Ll][Ee]\s*=\s*{\(\p\+\)}')
            if len(matched) > 1
              let item.menu = get(matched, 1)
              call add(completion.words, item)
              let item = {}
            endif
          endif
        endfor
      endfor
    endif

    " We need reference completion.
    if line[start - 4:start] =~ "ref{"
      for texfile in glob('**/*.tex', 0, 1)
        for line in readfile(texfile)
          " this does not match labels when a percentage sign is preceeding
          let matched = matchlist(line, '\(%.*\)\@<!\\label{\(' . a:base . '[0-9a-zA-Z:]*\)}')
          if len(matched) > 1
            let item = {}
            let item.word = get(matched, 2)
            let item.abbr = '[' . item.word . ']'
            let item.menu = texfile
            call add(completion.words, item)
          endif
        endfor
      endfor
    endif

    return completion

  endif
endfun
set omnifunc=CompleteTex

" Make a label for the section definition under the cursor
function! s:LabelSection()
  let matched = matchlist(getline("."), '^\\[sub]*section{\(.*\)}$')
  if len(matched) > 1
    let label = get(matched, 1)
    let label = tolower(label)
    let label = substitute(label, ' ', '_', 'ge')
    let label = substitute(label, 'ä', 'ae', 'ge')
    let label = substitute(label, 'ö', 'oe', 'ge')
    let label = substitute(label, 'ü', 'ue', 'ge')
    exec printf('normal o\label{sec:%s}', label)
  else
    echohl WarningMsg | echom "Not on a line with a \[sub]section." | echohl None
  endif
endfun
command! -nargs=0 LabelSection call s:LabelSection()
