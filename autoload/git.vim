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
        nnoremap <buffer> <nowait> <silent> [q :call <SID>handle_conflicted_file('previous')<CR>
        nnoremap <buffer> <nowait> <silent> ]q :call <SID>handle_conflicted_file('next')<CR>
    endif
endfunction

" Abort git commit
function! git#gabort() abort
    let available_filetyps = ["gitcommit", "gitrebase"]
    if index(available_filetyps, &filetype) < 0
        call log#error("Gabort: Not in git commit")
        return
    endif

    " Empty the file and save it" really is
    " the official Git way of canceling a commit.
    %d
    write
    quit
endfunction

" Jump to the previous/next conflicting file in quickfix
" without breaking Gvdiffsplit!
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

