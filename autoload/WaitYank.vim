function! s:WaitYankAndPasteEnd() "{{{
    call setpos('.', b:WaitYankInfo.pos)
    let l:cpos = getpos('.')
    if l:cpos[2] != b:WaitYankInfo.pos[2] "col not equal paste after
        " feedkeys api input char in insert mode? not command in normal mode?
        exe printf('norm! %dp', b:WaitYankInfo.count)
    else
        exe printf('norm! %dP', b:WaitYankInfo.count)
    endif
    if b:WaitYankInfo.mode ==# 'i'
        call feedkeys('a', 'ni')
    endif
endfunction
"}}}
function! s:yop(type) "{{{
  normal! `[v`]y
  call s:WaitYankEnd(1)
endfunction
"}}}

function! s:WaitYankEnd(isCall)
    au! WaitYankAndPaste

    if a:isCall
        call feedkeys("\<C-\>\<C-N>:call b:WaitYankInfo.cb() | unlet! b:WaitYankInfo \<CR>")
    else
        unlet! b:WaitYankInfo
    endif
    if !exists("##TextYankPost")
        vunmap <buffer> y
        vunmap <buffer> Y
        nunmap <buffer> y
        nunmap <buffer> Y
    endif
endfunction

function! WaitYank#Wait(Callback)
  let @@ = ""

  let b:WaitYankInfo = {
        \ "pos"   : getpos('.'),
        \ "mode"  : mode()     ,
        \ "count" : v:count1   ,
        \ "cb"    : a:Callback ,
        \ }

  let existTextYankPost = exists("##TextYankPost")
  if !existTextYankPost
      xnoremap <silent><buffer> y y:call <SID>WaitYankEnd(1)<CR>
      xnoremap <silent><buffer> Y Y:call <SID>WaitYankEnd(1)<CR>
      nnoremap <silent><buffer> y :<C-U>set opfunc=<SID>yop<CR>g@
      nnoremap <silent><buffer> Y Y:call <SID>WaitYankEnd(1)<CR>
  endif

  augroup WaitYankAndPaste
    au!
    if existTextYankPost
        au TextYankPost <buffer> call <SID>WaitYankEnd(1)
    endif
    " au CursorMoved,CursorHold <buffer> if @@ != "" | call <SID>WaitYankAndPasteEnd(1) | endif
    au InsertEnter <buffer> call <SID>WaitYankEnd(0)
  augroup END

  return "\<C-\>\<C-N>"
endfunction

function! WaitYank#Paste() "{{{
    return WaitYank#Wait(function('s:WaitYankAndPasteEnd'))
endfunction
"}}}
