command -nargs=0 GMerge :call git#gmerge()
command -nargs=0 Gconflict :call asyncrun#run('', {'errorformat': '%f'}, "git diff --name-only --diff-filter=U")
command! -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
command! -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
command! -nargs=0 EchoPath :echo expand("%:p")
" Rename current file
command! -nargs=1 Rename try | execute "saveas %:p:h" . '/' . "<args>" | call delete(expand('#')) | bd # | endtry
command -nargs=0 ConfigUpdate call <SID>config_update()

command! Symbol call <SID>Symbol()

command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr s:grep(<f-args>)
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'

augroup quickfix
	autocmd!
	autocmd QuickFixCmdPost cgetexpr cwindow
augroup END

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

function! s:config_update() abort
    let config_dir = stdpath("config")
    execute "AsyncRun -cwd" config_dir "git pull"
endfunction

function! s:grep(...)
    return system(printf("%s '%s'", &grepprg, join(a:000, '')))
endfunction

