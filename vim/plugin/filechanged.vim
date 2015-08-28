"
" From: http://vim.wikia.com/wiki/File_no_longer_available_-_mark_buffer_modified
"
" Vim notices the file for a buffer being edited has been deleted
" (e.g. after running a shell command), it raises error E221 to warn the user.
"
" An additional behaviour desired by some is to also mark the buffer as 'modified'
" so that it can't be abandoned without providing a bang (!).
"
" If the file has been changed but not modified in the current buffer, just
" reload it
"
au FileChangedShell * call FCSHandler(expand("<afile>:p"))
function FCSHandler(name)
  let msg = 'File "'.a:name.'"'
  let v:fcs_choice = ''
  if v:fcs_reason == "deleted"
    let msg .= " no longer available - 'modified' set"
    call setbufvar(expand(a:name), '&modified', '1')
    echohl WarningMsg
  elseif v:fcs_reason == "time"
    let msg .= " timestamp changed"
    " Do nothing
  elseif v:fcs_reason == "mode"
    let msg .= " permissions changed"
    " Do nothing
  elseif v:fcs_reason == "changed"
    let msg .= " contents changed"
    let v:fcs_choice = "reload"
  elseif v:fcs_reason == "conflict"
    let msg .= " CONFLICT --"
    let msg .= " is modified, but"
    let msg .= " was changed outside Vim"
    let v:fcs_choice = "ask"
    echohl ErrorMsg
  else  " unknown values (future Vim versions?)
    let msg .= " FileChangedShell reason="
    let msg .= v:fcs_reason
    let v:fcs_choice = "ask"
    echohl ErrorMsg
  endif
  redraw!
  echomsg msg
  echohl None


endfunction








