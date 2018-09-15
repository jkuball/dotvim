" Set default latex compiler
compiler latexmk

"" For vim-surround (see :h surround-customizing):
" Use the \ character for begin/end pairs
let g:surround_{char2nr('\')} = "\\begin{\1environment: \1}\r\\end{\1\1}"
" Use the / character for inline \command{}
" (Not the best key, but okayish mnemonic-wise)
let g:surround_{char2nr('/')} = "\\\1command: \1{\r}"

" After writing \begin{environment} use <c-j> to insert the corresponding \end
" TODO Maybe look into tpopes endwise for a proper replacement
function! CompleteBegin()
  let line = getline('.')
  let pos = getpos('.')
  let matched = matchlist(line, '^\\begin{\(.*\)}$')
  if len(matched) > 1 && pos[2] >= len(line)
    exec printf('normal! o\end{%s}', get(matched, 1))
    normal! O
  else
    " This is bad, but 'normal! i<c-j>' does not work for whatever reason
    " When viewed at github, this might look like 'normal! i',
    " but there is a ^M character following.
    normal! i
  endif
endfunction
inoremap <c-j> <c-o>:call CompleteBegin()<cr>

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
          let matched = matchlist(line, '\(%.*\)\@<!\\label{\(' . a:base . '\p*\)}')
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
    for [pattern, replacement] in
          \ [
          \   [' ', '_'],
          \   ['-', ''],
          \   ['ä', 'ae'],
          \   ['ö', 'oe'],
          \   ['ü', 'ue'],
          \   ['[,?!-()]', ''],
          \   ['\\\w\+{\(.\+\)}', '\1']
          \ ]
      let label = substitute(label, pattern, replacement, 'ge')
    endfor
    exec printf('normal! o\label{sec:%s}', label)
  else
    echohl WarningMsg | echom "Not on a line with a \[sub]section." | echohl None
  endif
endfun
command! -nargs=0 LabelSection call s:LabelSection()
