" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Moves the window to the top-left location
" Also, resize it to a proper size
function! s:setup_window()
	wincmd H
endfunction

autocmd WinEnter <buffer> call <SID>setup_window()
autocmd BufEnter <buffer> call <SID>setup_window()
call <SID>setup_window() "autocmd FileType

" Automatically resize the window vertically
if &textwidth == 0
	setlocal textwidth=80
endif
call AutoWidth()
