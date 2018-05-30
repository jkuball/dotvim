let g:clang_compilation_database = './build'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
let g:clang_auto = 0
autocmd CompleteDone * ClangCloseWindow
