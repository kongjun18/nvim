" Autocmd
" Last Change: 2021-10-19
" Author: Kong Jun <kongjun18@outlook.com>
" Github: https://github.com/kongjun18
" License: GPL-2.0

if exists('g:loaded_autocmd_vim') || &cp || version < 700
    finish
endif
let g:loaded_autocmd_vim = 1

" filename~upperdir~date
let &backupext = '~' . expand('%:p:h:t') . '~' . strftime("%Y-%m-%d")

augroup format
    autocmd BufWritePre * call <SID>remove_trailing_space()
    autocmd BufWritePre *.vim if &modified | :call <SID>update_timestamp() | endif
augroup END

" Add git conflict maker to machit
autocmd BufReadPre * let b:match_words = '^<<<<<<<:^|||||||:^=======:^>>>>>>>'

" Update timestamp Last Change: YEAR-MONTH-DAY in copyright notice
function s:update_timestamp()
    let l:save_window = winsaveview()
    normal gg
    try
        let l:author_is_kongjun = search('^" Author: Kong Jun <kongjun18@outlook.com>', 'n', 10)
        if l:author_is_kongjun && !search('^" Last Change: ' .. strftime("%Y-%m-%d"))
            silent execute '1, 10s/^" Last Change:\s\+\zs\d\+-\d\+-\d\+\s*$/' .. strftime("%Y-%m-%d")
        endif
    catch //
        call winrestview(l:save_window)
        return
    endtry
    call winrestview(l:save_window)
endfunction

function s:remove_trailing_space() abort
    if &modified && &ft !~? '.*git.*'
        let l:cursor = getcurpos()
        :keepmarks %s/\s\+$//ge
        call setpos('.', l:cursor)
    endif
endfunction
