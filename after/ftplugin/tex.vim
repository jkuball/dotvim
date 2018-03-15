" Omnicompletion for \cite{}'s.
" Scans all ./*.bib files for lines that match this pattern: @TYPE{NAME,
" (NAME will be completed and TYPE could be anything containing alphanumerical characters and colons):
" Also, every entry needs to have a title.
fun! CompleteBib(findstart, base)
  if a:findstart
    let line = getline(".")
    let start = col(".") - 1
    let citematch = match(line, "\\cite{")
    if citematch == -1 " no cite in the current line
      return -3 " theoretically this should return -1 to throw an error, but this looks like it's broken
    endif
    while start > 0 && line[start - 1] =~ "[0-9A-Za-z:]"
      let start -= 1
    endwhile
    if (citematch - start) != -4 " this is -4 if the cursor is exact on the { of \cite{
      return -3
    endif
    return start
  else
    let completion = { 'words': [], 'refresh': 'always' }
    for bibfile in split(globpath('.', '*.bib'))
      let content = readfile(bibfile)
      let item = {}
      for line in content
        if !has_key(item, 'word')
          let matched = matchlist(line, '@.\+{\(' . a:base . '[0-9a-zA-Z:]\+\),')
          if len(matched) > 1
            let item.word = get(matched, 1)
            let item.abbr = '[' . get(matched, 1) . ']'
          endif
        else
          let matched = matchlist(line, '\s*[Tt][Ii][Tt][Ll][Ee]\s*=\s*{\(\p\+\)}')
          if len(matched) > 1
            let item.menu = get(matched, 1, '[ERROR]')
            call add(completion.words, item)
            let item = {}
          endif
        endif
      endfor
    endfor
    return completion
  endif
endfun
set omnifunc=CompleteBib

