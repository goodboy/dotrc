" function! toggle#ToggleList(bufname, pfx)
function! s:check_and_lint()
    let l:qflist = ghcmod#make('check')
    call extend(l:qflist, ghcmod#make('lint'))
    call setqflist(l:qflist)
    cwindow
    if empty(l:qflist)
        echo "No errors found"
    endif
endfunction
" au BufWritePost *.hs call s:check_and_lint()
