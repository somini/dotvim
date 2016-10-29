" Ignore certain filetypes
if index(['gitcommit'], &ft) == -1
	" Move vertically by display lines
	noremap <buffer> j gj
	noremap <buffer> gj j
	noremap <buffer> k gk
	nnoremap <buffer> gk k
endif
