" My ~/.vim/vimrc
" Author: Jonas Kuball <jkuball@tzi.de>

" Firstly, load sensible.vim to have sane defaults set
packadd vim-sensible

" Use vim-colors-github
"" Better gutter marks
let g:github_colors_block_diffmark = 0
"" load colorscheme
colorscheme github
"" fix bad highlighting
highlight StatusLineNC cterm=bold ctermfg=15 ctermbg=242 gui=bold guifg=White guibg=Grey40

" Allow easy :argdo modifications etc.
set hidden

" Default indentation, might be overwritten for specific filetypes
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Never lose anything
for type in ["swap", "backup", "undo"]
  if !isdirectory(expand("$HOME/.vim/." . type . "files//"))
    call mkdir(expand("$HOME/.vim/." . type . "files//"))
  endif
endfor
set backup
set undofile
set directory=$HOME/.vim/.swapfiles//
set backupdir=$HOME/.vim/.backupfiles//
set undodir=$HOME/.vim/.undofiles//

" Set leader(s)
let mapleader="\<Space>"
let maplocalleader=","

" No mouse in insert mode
set mouse=nv

" Line numbering
set nu

" No ex mode
map Q gq

" Set spelling languages
set spelllang=de,en_us

" Convenience Mappings
nnoremap ZZ :wq<cr>
nnoremap XX :q!<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap S c$

" Open terminal in a tab
nnoremap <leader>t :tabedit \| :terminal ++curwin<cr>

" Open a local TODO file
nnoremap <leader>o :tabedit todo.org<cr>

" When on mac, set the insert mode cursor correctly
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"" Better refactoring/multiple replacements. Thanks to
"" kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"
nnoremap cn *''cgn
nnoremap cN *''cgN
vnoremap <expr> cn g:mc . "''cgn"
vnoremap <expr> cN g:mc . "''cgN"

" Align the paragraph with the top of the screen
nnoremap gzz {jzt``

" Re-generate helptags
command! Helptags helptags ALL

" Open windows below (escpically the preview window)
set splitbelow

" When on macOS, wildignore .DS_Store
if has('mac')
  set wildignore+=*.DS_Store
endif

" Define some digraphs for writing german text
exec "digraphs ae " . char2nr('ä')
exec "digraphs ue " . char2nr('ü')
exec "digraphs oe " . char2nr('ö')
exec "digraphs ss " . char2nr('ß')

" When on mac, define the :Dict command
if has('mac')
  command! -nargs=1 Dict call execute("!open dict://" . <f-args>) | redraw!
endif

" Set the tex flavor to latex since that's what I write the most
let g:tex_flavor = "latex"

" Just a small convenience thing for myself that might be enough
" to make into a proper plugin. I noticed a pattern in my workflow
" where a simple :Make is not enough, so this helps with non-standard
" build commands. For instance, when in a python script, you can call
" `:ActivateTermBuild python3 myscript.py --some --arguments 42` to open
" a terminal and setup m<cr> to send the previously given command to it.
" It only starts a new terminal if one is not already present, so you can use
" it to update the build command.
function! OpenTermForBuild(buildcommand)
  if bufnr('!' . &shell) < 0
    let pos = getcurpos()
    let buffernumber = term_start(&shell, { 'term_rows': 10 })
    call win_gotoid(buffernumber)
    let &l:winfixheight = 10
    call setpos('.', pos)
  endif
  exec "nnoremap <silent> m<cr> :call term_sendkeys(bufnr('!' . &shell), \"\\<lt>c-c>\\<lt>c-l>" . a:buildcommand . "\\<lt>cr>\")<cr>"
endfunction
command! -nargs=1 -complete=file ActivateTermBuild call OpenTermForBuild(<q-args>)

" Supply the :Shebang command which inserts the contents of the
" variable b:shebang. It needs to be set for each filetype in
" after/ftplugin/filetype.vim
command! -nargs=0 Shebang if exists("b:shebang") |
      \ exec 'normal!ggO' . b:shebang |
      \ else |
      \ echohl WarningMsg |
      \ echo "No shebang specified for " . expand(&ft) |
      \ echohl None |
      \ endif

" Supply the :Lint command which fills the quickfix list with the output
" of the shell program that's set in the variable b:linter. It needs to
" be set for each filetype in after/ftplugin/filetype.vim
"" TODO if needed, custom errorformat, read from stdin or not, etc
function! Lint(lintcmd)
  let l:linter = a:lintcmd
  if strlen(l:linter) <= 0
    if !exists("b:linter")
      echohl WarningMsg | echo "No linter specified for " . expand(&ft) | echohl None
      return
    else
      let l:linter = b:linter
    endif
  endif
  if !executable(split(l:linter)[0])
    echohl WarningMsg | echo "No such executable " . l:linter | echohl None
    return
  endif
  cgetexpr system(l:linter . ' ' . expand('%'))
  if len(getqflist()) > 0
    copen
  else
    echo "Linting done, output empty."
  endif
endfunction
command! -nargs=? -complete=shellcmd Lint call Lint(<q-args>)
nnoremap <leader>l :Lint<cr>

" Placeholder Helper
function! JumpToNextAndSelect(target, backwards)
  let l:flags = 'z'
  if a:backwards
    let l:flags = 'b' . 'z'
  endif
  if search(a:target, l:flags)
    exec "normal v" . (strlen(a:target)-1) . "l\<c-g>"
  endif
endfunction

" Use :Redir to execute any Ex command and pipe the output to a scratch buffer
" Adapted from reddit user /u/-romainl-
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let output = system(matchstr(a:cmd, '^!\zs.*'))
  else
    redir => output
    execute a:cmd
    redir END
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 -complete=command Redir silent call Redir(<q-args>)

" For python, set the executable correctly, so vim-apathy sets the path
" correctly. This can be removed on systems where the default python
" IS python3, but that's just a dream (until macOS finally ditches all
" scripting languages, which IS coming)
augroup Python
  au!
  au BufReadPre *.py let g:python_executable = "python3"
augroup END

" fugitive-gitlab.vim
let g:fugitive_gitlab_domains = ['https://gitlab.informatik.uni-bremen.de']

" vim-rsi
"" Disable meta mappings because ä is the same as <M-d>.
"" See https://github.com/tpope/vim-rsi/issues/14
let g:rsi_no_meta = 1

" Set custom status line
set statusline=%(%q%h%r\ %)%t\ %y%m
set statusline+=%= " everything below this is right justified (mostly for plugins)

" If git is installed, use vim-fugitive.
if executable("git")
  packadd vim-fugitive
  set statusline+=%([git:%{fugitive#head()}]%)

  " :Gstatus for the current file's repository in a new tab
  nnoremap <leader>g :tabedit % \| :Gstatus \| :only<cr>
endif

" If ag is installed, use ack.vim
if executable("ag")
  packadd ack.vim
  let g:ackprg = 'ag --vimgrep'
endif
