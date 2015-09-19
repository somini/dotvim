" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Close help with F1
nnoremap <silent> <buffer> <nowait> <F1> :close<CR>
nmap <buffer> <nowait> <C-F1> <F1>
nmap <buffer> g<F1>  <C-F1>
