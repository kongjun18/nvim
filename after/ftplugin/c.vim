" Settings for C
" Last Change: 2022-01-23
" Author: Kong Jun <kongjun18@outlook.com>
" Github: https://github.com/kongjun18
" License: GPL-2.0

" Support Chinese version of GNU Make
setlocal errorformat+=
            \%D%*\\a[%*\\d]:\ 进入目录“%f”,
            \%X%*\\a[%*\\d]:\ 离开目录“%f”,
            \%D%*\\a:\ 进入目录“%f”,
            \%X%*\\a:\ 离开目录“%f”,
            \%+GIn\ file\ included\ from\ %f:%l:,
            \%+GIn\ file\ included\ from\ %f:%l:%c:
