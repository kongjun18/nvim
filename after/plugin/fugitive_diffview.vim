function! s:MapFugitiveDiffview() abort
  if exists("*FugitiveGitDir") && !empty(FugitiveGitDir())
    nnoremap <buffer> <silent> <nowait> d <Cmd>lua require("modules.vcs.fugitive_diffview").open()<CR>
  endif
endfunction

" Fugitive object buffers often keep the real filetype, so hook Fugitive events.
augroup FugitiveDiffview
  autocmd!
  autocmd User FugitiveIndex,FugitiveObject,FugitiveStageBlob,FugitivePager call <SID>MapFugitiveDiffview()
augroup END
