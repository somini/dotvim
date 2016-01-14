" Go to the first line
goto
" If the first line is empty, start insert mode
if getline(1) ==# ''
	startinsert
endif
