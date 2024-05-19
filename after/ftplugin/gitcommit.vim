" Language-specific configuration of gitcommit
" Last Change: 2022-01-23
" Author: Kong Jun <kongjun18@outlook.com>
" Github: https://github.com/kongjun18
" License: GPL-3.0

setlocal wrap           " Wrap line
setlocal spell          " Enable spell checking
cmap <buffer> q! Gabort
" Load on BufferEnter to parse in advance.
lua require("cmp_dictionary").update()
