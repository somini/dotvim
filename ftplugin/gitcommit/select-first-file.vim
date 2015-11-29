if !exists('g:loaded_fugitive')
	finish "Only if Fugitive is loaded
endif

autocmd BufEnter <buffer> call <SID>select_first()

let s:selected = 0
function! s:select_first()
	" Only on modifiable buffers
	if !&modifiable
		setlocal cursorline
		if !s:selected
			" Go to the first file
			execute 'normal' "gg\<C-n>"
			let s:selected = 1
		endif
	endif
endfunction
