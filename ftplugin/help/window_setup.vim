" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Resize it to a proper size
if &textwidth == 0
	setlocal textwidth=80
endif

" Moves the window to the top-left location
function! s:setup_window()
	wincmd H
	call AutoWidth()
endfunction

autocmd WinEnter <buffer> call <SID>setup_window()
autocmd BufEnter <buffer> call <SID>setup_window()
call <SID>setup_window() "autocmd FileType
