" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Less-like
runtime scripts/less.vim

" Keep the old values
nnoremap <buffer> <Leader>f f

" Search for new stuff, à lá Vimperator
nnoremap <buffer> f :help<Space>
