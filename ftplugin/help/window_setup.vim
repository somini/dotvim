" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Resize the window
execute 'vertical' 'resize' (&textwidth == 0 ? 80 : &textwidth)

" Moves the window to the top-left apartment
function! s:move_window()
	wincmd H
endfunction

autocmd WinEnter <buffer> call <SID>move_window()
autocmd BufEnter <buffer> call <SID>move_window()
