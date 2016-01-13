" Automatically resize the window vertically
let b:auto_width_do = 1

" Moves the window to the top-left location
" Also, resize it to a proper size
function! s:setup_window()
	wincmd L
	call AutoWidth()
endfunction

autocmd WinEnter <buffer> call <SID>setup_window()
autocmd BufEnter <buffer> call <SID>setup_window()
