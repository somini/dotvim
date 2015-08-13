" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Moves the window to the top-left apartment
function! s:move_window()
	wincmd H
endfunction

autocmd WinEnter <buffer> call <SID>move_window()
autocmd BufEnter <buffer> call <SID>move_window()
