" Go to the first line and start insert mode
" Only if the first line is empty
if getline(1) ==# ''
	goto
	startinsert
endif
