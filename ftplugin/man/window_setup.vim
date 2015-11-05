" Moves the window to the top-left location
" Also, resize it to a proper size
function! s:setup_window()
	wincmd H
endfunction

autocmd WinEnter <buffer> call <SID>setup_window()
autocmd BufEnter <buffer> call <SID>setup_window()
call <SID>setup_window() "autocmd FileType
