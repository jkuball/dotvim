" Vim Compiler File
" Compiler:	latexmk
" Maintainer:	Jonas Kuball <jkuball@tzi>
" Last Change: Tue  3 Jul 2018 10:43:47 CEST

if exists("b:current_compiler") | !executable("rubber-info") | !executable("latexmk")
    finish
endif
let b:current_compiler = "latexmk"

" Set the compiler to a helper script which first compiles with latexmk and
" then uses rubber-info to extract the warnings. Parsing latex compiler output
" with vims scanf-based errorformat is really bad.
CompilerSet makeprg=$HOME/.vim/after/compiler/latexmk-helper.sh\ %:p

" rubber-info --errors
CompilerSet errorformat+=%f:%l:%m
CompilerSet errorformat+=%f:%l-%.%#:%m
CompilerSet errorformat+=%f:%m

" Now ignore everything unmatched (Maybe re-add later)
" CompilerSet errorformat+=%-W%.%#
