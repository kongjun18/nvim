if exists("g:loaded_customed_cmd")
    finish
endif
let g:loaded_customed_cmd = 1

function! cmd#symbal() abort
    let symbol = printf("`%s`", v:lua.require('nvim-navic').get_data()[0].name)
    call setreg('+', symbol)
endfunction

function! cmd#config_update() abort
    let config_dir = stdpath("config")
    execute "AsyncRun -cwd" config_dir "git pull --rebase"
endfunction

function! cmd#grep(pattern) abort
    let l:cmd = printf("%s '%s'", &grepprg, a:pattern)
    return system(l:cmd)
endfunction

function! cmd#grep_visual_selection()
    let l:pattern = utils#get_visual_selection()
    if l:pattern != ""
        cgetexpr cmd#grep(l:pattern) | copen
    endif
endfunction

function! cmd#search_in_browser(...) abort
    if len(a:000) > 1
        call log#error("Search: Too many arguments!")
    endif
    let l:keyword = get(a:000, 0, expand("<cword>"))

    let l:open = "xdg-open"
    let l:format = "http://www.google.com/search?q=%s"
    let l:command = printf("%s '%s'", l:open, printf(l:format, l:keyword))

    call system(l:command)
    if v:shell_error
        call log#error(printf("Search: Failed to open %s", printf(l:format, l:keyword)))
    else
        call log#info(l:command)
    endif
endfunction
