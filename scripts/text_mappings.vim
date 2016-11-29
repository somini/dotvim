" Ignore certain filetypes
if index(['gitcommit', 'help'], &ft) == -1
	" Move vertically by display lines
	noremap <buffer> j gj
	noremap <buffer> gj j
	noremap <buffer> k gk
	noremap <buffer> gk k
	" Move horizontally by display lines
	noremap <buffer> $ g$
	noremap <buffer> g$ $
	noremap <buffer> 0 g0
	noremap <buffer> g0 0
endif
