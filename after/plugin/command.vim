" Resolve git conflicts
command -nargs=0 Gmerge :call git#gmerge()
" Abort git commit
command -nargs=0 Gabort call git#gabort()
" Display git conflicts in the quickfix window
command -nargs=0 Gconflict :call asyncrun#run('', {'errorformat': '%f'}, "git diff --name-only --diff-filter=U")
" Async git push
command -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
" Async git fetch
command -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
          \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
" Display the file path of the current buffer
command -nargs=0 EchoPath :echo expand("%:p")
" Rename current file
command -nargs=1 Rename try | execute "saveas %:p:h" . '/' . "<args>" | call delete(expand('#')) | bd # | endtry
" Update neovim configuration through 'git pull --rebase'
command -nargs=0 ConfigUpdate call cmd#config_update()
" Search keyword in browser.
" If keyword is not specified, use <cword>.
command -nargs=? Search call cmd#search_in_browser(<f-args>)
" Copy the current LSP symbol in markdown
" inline code format to system clipboard.
command -nargs=0 Symbol call cmd#symbal()
" Async ripgrep
command -nargs=? -complete=file_in_path -bar Grep cgetexpr cmd#grep(<f-args>) | copen
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
" Vertical vim-fugitive
command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#Complete G   exe "vertical" fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)
" Daily capture
command! Capture execute 'lua require("modules.misc.capture")()'
" Local Gbrowse
command! Browse execute 'lua require("modules.misc.browse")()'
