function! DiffSaved()
  w !diff % -
endfunction

function! VDiffSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

let s:last_saved_diff_open=0

function! ToggleVDiffSaved()
  if (s:last_saved_diff_open == 1)
    let s:last_saved_diff_open=0
    diffoff
    clo
  else
    let s:last_saved_diff_open=1
    VDiffSaved
  endif
endfunction

command! DiffSaved
  \ call DiffSaved() 

command! VDiffSaved
  \ call VDiffSaved() 

command! ToggleVDiffSaved
  \ call ToggleVDiffSaved()  

nnoremap <leader>ds :ToggleVDiffSaved<cr>

