" Configuration for man page
" Last Change: 2022-01-25
" Author: Kong Jun <kongjun18@outlook.com>
" Github: https://github.com/kongjun18
" License: GPL-2.0

" grab C++ standard library symbol under the cursor correctly
setlocal iskeyword+=:,(,)
setlocal iskeyword-=.
setlocal colorcolumn=0 " Disable 80 column highlight
