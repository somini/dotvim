" Moves the window to the top-left location
" Also, resize it to a proper size
function! s:setup_window()
	wincmd H
endfunction

call <SID>setup_window() "autocmd FileType
