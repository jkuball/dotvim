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
" with vims errorformat is really bad.
CompilerSet makeprg=$HOME/.vim/after/compiler/latexmk-helper.sh

" Since latex has a bunch of useless warnings, most of the following
" parser are commented out.

" rubber-info --check
CompilerSet errorformat=
      \%tHECK:%f:%l%.%#:\ %m,
      \%tHECK:%f:\ %m

" rubber-info --errors
CompilerSet errorformat+=
      \%tRROR:%f:%l%.%#:\ %m,
      \%tRROR:%f:\ %m

" " rubber-info --warnings
" CompilerSet errorformat+=
"       \%tARNING:%f:%l%.%#:\ %m,
"       \%tARNING:%f:\ %m

" " rubber-info --boxes
" CompilerSet errorformat+=
"       \%tOXES:%f:%l%.%#:\ %m,
"       \%tOXES:%f:\ %m

" Now ignore everything unmatched
CompilerSet errorformat+=%-W%.%#
