" Moves the window to the top-left location
function! s:setup_window()
	wincmd H
endfunction

call <SID>setup_window() "autocmd FileType

" Automatically resize the window vertically
let b:auto_width_do = 1
setlocal textwidth=80
call AutoWidth()
