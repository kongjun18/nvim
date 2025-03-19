if exists("g:loaded_customed_utils")
    finish
endif
let g:loaded_customed_utils = 1

function! utils#get_visual_selection()
    let l:old_reg = getreg('z')
    noau normal! "zy"
    let l:selected = getreg('z')
    call setreg('z', l:old_reg)
    return l:selected
endfunction
