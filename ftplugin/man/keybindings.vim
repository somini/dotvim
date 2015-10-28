" Only on vim-man buffers, to be able to edit helpfiles
if &buftype != 'nofile'
	finish
endif

" Less-like
runtime scripts/less.vim

" Keep the old values
nnoremap <buffer> <Leader><Leader><Leader>f f

" Search for new stuff, à lá Vimperator
nnoremap <buffer> f :Man<Space>

" F1 to close, why not?
nnoremap <buffer> <F1> ZQ
