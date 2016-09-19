" Only on help buffers, to be able to edit helpfiles
if &buftype != 'help'
	finish
endif

" Less-like
runtime scripts/less.vim
nunmap <buffer> <A-h>
nunmap <buffer> <A-l>

" Keep the old values
nnoremap <buffer> <Leader><Leader><Leader>f f

" Search for new stuff, à lá Vimperator
nnoremap <buffer> f :help<Space>
