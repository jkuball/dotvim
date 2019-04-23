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
set backup
set undofile
set directory=$HOME/.vim/.swapfiles//
set backupdir=$HOME/.vim/.backupfiles//
set undodir=$HOME/.vim/.undofiles//

" Set leader
let mapleader="\<Space>"
let maplocalleader="\<Space>"

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

" Open terminal in a tab
nnoremap <leader>t :tabe \| :term ++curwin<cr>

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

" Set the tex flavor to latex since that's what I write the most
let g:tex_flavor = "latex"

" Just a small convenience thing for myself that might be enough
" to make into a proper plugin. I noticed a pattern in my workflow
" where a simple :Make is not enough, so this helps with non-standard
" build commands. For instance, when in a python script, you can call
" `:ActivateTermBuild python3 myscript.py --some --arguments 42` to open
" a terminal and setup <c-m> to send the previously given command to it.
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
  exec "nnoremap <silent> m<cr> :call term_sendkeys(bufnr('!' . &shell), \"\\<lt>c-l>" . a:buildcommand . "\\<lt>cr>\")<cr>"
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
      echohl WarningMsg
      echo "No linter specified for " . expand(&ft)
      echohl None
      return
    else
      let l:linter = b:linter
    endif
  endif
  if !executable(l:linter)
    echohl WarningMsg
    echo "No such executable " . l:linter
    echohl None
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

" Define Placeholders that can be used everywhere, but mostly will be in the
" Skeleton stuff below
let g:placeholder = '<!!>'
command! -nargs=1 Pnext call JumpToNextAndSelect(<f-args>, 0)
command! -nargs=1 Pprev call JumpToNextAndSelect(<f-args>, 1)
nnoremap <silent><expr> <leader>n ":Pnext " . g:placeholder . "<cr>"
nnoremap <silent><expr> <leader>p ":Pprev " . g:placeholder . "<cr>"
snoremap <silent><expr> <leader>n "<esc>:Pnext " . g:placeholder . "<cr>"
snoremap <silent><expr> <leader>p "<esc>:Pprev " . g:placeholder . "<cr>"
nnoremap <silent><expr> <leader>ip "a" . g:placeholder . "<esc>"
augroup Placeholder
  au!
  au syntax * highlight Placeholder ctermfg=26 ctermbg=255 guifg=#22863a guibg=#005cc5
  au syntax * call matchadd("Placeholder", g:placeholder)
augroup END

" Supply the :Skeleton command which searches in
" $HOME/.vim/skeleton/<filetype> for .skel files,
" lets you choose one and inserts them into the buffer (ontop).
" Also evaluates vimscript code in the skeletons that is enclosed by <{ and }>.
function! InsertSkeleton()
  let files = glob("$HOME/.vim/skeleton/" . expand(&ft) . "/*.skel", 0, 1)
  if len(files) <= 0
    echohl WarningMsg | echo "No skeleton files specified for " . expand(&ft) | echohl None
  else
    if len(files) == 1
      exec "0read " . files[0]
      %s/<{\(.\{-}\)}>/\=eval(submatch(1))/g
      normal 0d1
    else
      let skeletons = map(copy(files), "fnamemodify(v:val, ':t:r')")
      for idx in range(len(skeletons))
        let skeletons[idx] = (idx + 1) . ": " . skeletons[idx]
      endfor
      call insert(skeletons, "Select skeleton (empty cancels)", 0)
      let index = inputlist(skeletons) - 1
      try
        if index < 0
          throw 1
        endif
        exec "0read " . files[index]
        %s/<{\(.\{-}\)}>/\=eval(submatch(1))/g
        normal 0d1
      catch
        echohl WarningMsg | echo "\nInvalid selection" | echohl None
      endtry
    endif
  endif
endfunction
command! -nargs=0 Skeleton call InsertSkeleton()

" When opening skeleton files, load the correct filetype by looking at
" the folder name.
augroup SkeletonFiles
  au!
  au BufReadPost *.skel let &l:ft = fnamemodify(expand('%:p:h'), ':t')
  au BufReadPost *.skel highlight SkeletonCode ctermfg=29 ctermbg=255 guifg=#22863a guibg=#fafbfc
  au BufReadPost *.skel highlight SkeletonCodeDelim ctermfg=250 ctermbg=255 guifg=#babbbc guibg=#fafbfc
  au BufReadPost *.skel call matchadd("SkeletonCodeDelim", "<{.\\{-\}}>")
  au BufReadPost *.skel call matchadd("SkeletonCode", "<{\\zs.\\{-\}\\ze}>")
augroup END

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
