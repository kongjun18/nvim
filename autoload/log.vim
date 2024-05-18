if exists("g:loaded_customed_log")
    finish
endif
let g:loaded_customed_log = 1

function! log#error(msg) abort
    echohl ErrorMsg | echo a:msg | echohl None
endfunction

function! log#fatal(msg) abort
    ehcoerr a:msg
endfunction

function! log#info(msg) abort
    echomsg a:msg
endfunction

function! log#warn(msg) abort
    echohl WarningMsg | echo a:msg | echohl None
endfunction
