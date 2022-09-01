command -nargs=0 ConfigUpdate call <SID>config_update()
function! s:config_update() abort
    let config_dir = stdpath("config")
    execute "AsyncRun -cwd" config_dir "git pull"
endfunction
