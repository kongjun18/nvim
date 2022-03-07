" Language-specific configuration of gitcommit
" Last Change: 2022-01-23
" Author: Kong Jun <kongjun18@outlook.com>
" Github: https://github.com/kongjun18
" License: GPL-3.0

setlocal wrap           " Wrap line
setlocal spell          " Enable spell checking
" Initialize cmp-dictionary manually.
" Because cmp-dictionary is loaded later than BufEnter event, cmp-dictionary's
" BufEnter autocmds are not triggered.
lua require("cmp").register_source("dictionary", require("cmp_dictionary").new())
lua require("cmp_dictionary.caches").update()
