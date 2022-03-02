" Configuration of quickfix
" Last Change: 2022-01-25
" Author: Kong Jun <kongjun18@outlook.com>
" Github: https://github.com/kongjun18
" License: GPL-3.0

setlocal colorcolumn=0
setlocal relativenumber
setlocal wrap
nnoremap <buffer> <silent> q :wincmd q<CR>
nnoremap <buffer> <silent> <Esc> :wincmd q<CR>
setlocal nohlsearch
noremap <buffer> <silent> j <Cmd>call <SID>next_quickfix_item()<CR>
noremap <buffer> <silent> k <Cmd>call <SID>previous_quickfix_item()<CR>

function s:next_quickfix_item() abort
            let l:lnum = search('\v^[^\|]', 'W')
            if l:lnum == 0
                        echohl WarningMsg | echo "This is the last item" | echohl None
            endif
endfunction

function s:previous_quickfix_item() abort
            let l:lnum = search('\v^[^\|]', 'Wb')
            if l:lnum == 0
                        echohl WarningMsg | echo "This is the first item" | echohl None
            endif
endfunction

