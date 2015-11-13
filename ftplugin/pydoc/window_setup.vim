" Moves the window to the top-left location
" Also, resize it to a proper size
function! s:setup_window()
	wincmd H
endfunction

autocmd WinEnter <buffer> call <SID>setup_window()
autocmd BufEnter <buffer> call <SID>setup_window()
call <SID>setup_window() "autocmd FileType

" Automatically resize the window vertically
setlocal textwidth=80
let b:auto_width_do = 1
