if exists('*tlib#dir#CD') && exists('b:NERDTree')
	call tlib#dir#CD(b:NERDTree.root.path.str(), 1)
endif
