" Only on vim-man buffers, to be able to edit helpfiles
if &buftype != 'nofile'
	finish
endif

" Moves the window to the top-left location
" Also, resize it to a proper size
function! s:setup_window()
	wincmd H
	execute 'vertical' 'resize' (&textwidth == 0 ? 100 : &textwidth + 2)
endfunction

autocmd WinEnter <buffer> call <SID>setup_window()
autocmd BufEnter <buffer> call <SID>setup_window()
