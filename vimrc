" My ~/.vim/vimrc
" Author: Jonas Kuball <jkuball@tzi.de>

" Firstly, load sensible.vim to have sane defaults set
packadd vim-sensible

" Use vim-color-solarized in light mode by default
set background=light
colorscheme solarized

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

" Supply the :Skeleton command which searches in
" $HOME/.vim/skeleton/<filetype> for .skel files,
" lets you choose one and inserts them into the buffer (ontop).
function! InsertSkeleton()
  let files = glob("$HOME/.vim/skeleton/" . expand(&ft) . "/*.skel", 0, 1)
  if len(files) <= 0
    echohl WarningMsg | echo "No skeleton files specified for " . expand(&ft) | echohl None
  else
    if len(files) == 1
      exec "0read " . files[0]
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
        normal 0d1
      catch
        echohl WarningMsg | echo "\nInvalid selection" | echohl None
      endtry
    endif
  endif
endfunction
command! -nargs=0 Skeleton call InsertSkeleton()

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

" vim-lsc
"" Disable automatic completion
let g:lsc_enable_autocomplete = 0
"" Use sensible mappings for lsp-enabled filetypes
let g:lsc_auto_map = 1
"" Use omnifunc instead of completefunc
let g:lsc_auto_map = {
      \ 'defaults': 1,
      \ 'Completion': "omnifunc"
      \ }
"" Disable diagnostics
let g:lsc_enable_diagnostics = 0
"" Define servers for filetypes
let g:lsc_server_commands = {
      \   'python': 'pyls',
      \ }

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
endif

" If ag is installed, use ack.vim
if executable("ag")
  packadd ack.vim
  let g:ackprg = 'ag --vimgrep'
endif
