" Only on helpfiles
if &buftype == 'help'
	finish
endif

function! s:setup()
	" Turn off conceal, to be able to edit things more easily
	setlocal conceallevel=0
	" Always show the cursor location
	setlocal concealcursor=
endfunction

autocmd BufEnter,FileType <buffer> call <SID>setup()
