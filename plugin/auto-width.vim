" Auto-Width
" Resize the window based on textwidth, for certain filetypes
" Defaults to help files only

if !exists("g:auto_width_filetypes")
	let g:auto_width_filetypes = ['help']
endif

function AutoWidth()
	" b:auto_width_do overrrides the filetype check
	if exists('b:auto_width_do')
		if !b:auto_width_do
			return
		endif
	elseif count(g:auto_width_filetypes,&ft) != 1
		return
	endif
	if &textwidth > 20 "Bare minimum
		let l:v_size = &textwidth + 2
	else
		let l:v_size = 80
	endif
	call s:resize_vertical(l:v_size)
endfunction

function <SID>resize_vertical(width)
	exec 'vertical resize '.a:width
endfunction

" Set window width to textwidth + 2
augroup auto_width
	autocmd!
	autocmd VimResized  * call AutoWidth()
	autocmd BufWinEnter * call AutoWidth()
	autocmd BufEnter    * call AutoWidth()
augroup END

" vim: ts=2 sw=2
