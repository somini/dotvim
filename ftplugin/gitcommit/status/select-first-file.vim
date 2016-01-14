autocmd BufEnter <buffer> call <SID>select_first()

let s:selected = 0
function! s:select_first()
	setlocal cursorline
	if !s:selected
		" Only once this script is sourced
		" Go to the first file
		execute 'normal' "gg\<C-n>"
		let s:selected = 1
	endif
endfunction
