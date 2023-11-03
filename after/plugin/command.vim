command -nargs=0 GMerge :call git#gmerge()
command -nargs=0 Gconflict :call asyncrun#run('', {'errorformat': '%f'}, "git diff --name-only --diff-filter=U")
command! -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
command! -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
command! -nargs=0 EchoPath :echo expand("%:p")
" Rename current file
command! -nargs=1 Rename try | execute "saveas %:p:h" . '/' . "<args>" | call delete(expand('#')) | bd # | endtry

command! Symbol call <SID>Symbol()

fun! s:execute_in_ssh() abort
    let ssh_tty = getenv("SSH_TTY")
    return ssh_tty != v:null
endfunction

fun! s:Symbol() abort
    let symbol = printf("`%s`", v:lua.require('nvim-navic').get_data()[0].name)
    call setreg('+', symbol)
    if s:execute_in_ssh()
        OSCYankRegister +
    endif
endfunction

