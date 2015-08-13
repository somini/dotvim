" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Close help with F1
nnoremap <buffer> <nowait> <F1> :close<CR>
