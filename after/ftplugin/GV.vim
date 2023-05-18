" Open Diffview.nvm
nmap <buffer> d .<C-u>DiffviewCommit<CR>
command! -nargs=1 DiffviewCommit DiffviewOpen <args>~1..<args>
