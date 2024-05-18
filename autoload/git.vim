if exists('g:loaded_customed_git')
    finish
endif
let g:loaded_customed_git = 1

" Resolve git conflicts
function git#gmerge() abort
    highlight! Green guifg=#618774
    call asyncrun#run('!', {'errorformat': '%f'}, "git diff --name-only --diff-filter=U")
    autocmd User AsyncRunStop ++once ++nested call <SID>gmerge_asyncrun_callback()
endfunction

function git#diff_updated_handler() abort
    if &diff
        nnoremap <buffer> <nowait> <silent> dp :diffput <SID>get_merged_file()<CR>|
        nnoremap <buffer> <nowait> <silent> gh :diffget //2<CR>]czz|
        nnoremap <buffer> <nowait> <silent> gl :diffget //3<CR>]czz|
        nnoremap <buffer> <nowait> <silent> [q :call <SID>handle_conflicted_file('previous')<CR>| nnoremap <buffer> <nowait> <silent> ]q :call <SID>handle_conflicted_file('next')<CR> else
        call <SID>local_unmap(['gh', 'gl', 'dp'])
    endif
endfunction

" Abort git commit
function! git#gabort() abort
    if &filetype !=# 'gitcommit'
        call log#error("Gabort: Not in git commit")
        return
    endif

    " Empty the file and save it" really is
    " the official Git way of canceling a commit.
    %d
    write
    quit
endfunction

" Jump to the previous/next conflicting file in quickfix without breaking
" Gvdiffsplit!
" param  direction  'previous' or 'next'
function s:handle_conflicted_file(direction) abort
    if &modified
        call log#error("Error: No write since last change, please save buffer.")
        return
    endif
    try
        execute 'c' .. a:direction
    catch /^Vim(\(cprevious\|cnext\)):E\d\+:/ " E553: No More Items
        call log#error("Error: No More Items")
        return
    endtry
    let l:local_bufnr = bufnr('//2')
    let l:target_bufnr = bufnr('//3')
    if l:local_bufnr > 0
        execute 'bdelete! ' .. l:local_bufnr
    endif
    if l:target_bufnr > 0
        execute 'bdelete! ' .. l:target_bufnr
    endif
    Gvdiffsplit!
    normal! gg
endfunction

" Unmap buffer mapping
" param  mappings  a list of mapping or a single mapping
function s:local_unmap(mappings)
    if type(a:mappings) == v:t_list
        for l:mapping in a:mappings
            if !empty(maparg(l:mapping))
                execute 'unmap <buffer> ' .. l:mapping
            endif
        endfor
    elseif type(a:mappings) == v:t_string
        if !empty(maparg(l:mapping))
            execute 'unmap <buffer> ' .. a:mappings
        endif
    endif
endfunction

" Get buffer name of merged file in vim-fugitive's 3 way diff
function s:get_merged_file()
    let l:name = bufname('//2')
    if !empty(l:name)
        return matchstr(l:name, '//2/\zs\f\+\ze')
    endif
    let l:name = bufname('//3')
    if !empty(l:name)
        return matchstr(l:name, '//2/\zs\f\+\ze')
    endif
    return l:name
endfunction

function s:gmerge_asyncrun_callback()
    let qf = getqflist()
    " Has conflicts?
    if len(qf) > 2
        cnext
        " Disable git-conflict.nvim
        lua pcall(function() require("git-conflict").clear() end, nil)
        Gvdiffsplit!
        lua pcall(function() require("git-conflict").clear() end, nil)
    else
        cclose
        echohl Green | echo "There are no git conflicts." | echohl None
    endif
endfunction

