" Only if Fugitive is loaded
" Only once for each file
if !exists('g:loaded_fugitive') || exists('b:fugitive_subtype')
	finish
endif

" Check what kind of Fugitive gitcommit buffer is this
let b:fugitive_subtype = ''
if &previewwindow && getbufvar('','fugitive_type') ==# 'index'
	" STATUS:
	let b:fugitive_subtype = 'status'
elseif &modifiable
	" COMMIT:
	let b:fugitive_subtype = 'commit'
endif

if !empty(b:fugitive_subtype)
	" Source all files from the corresponding subfolder
	execute 'runtime! ftplugin/'.&filetype.'/'.b:fugitive_subtype.'/*.vim'
endif
