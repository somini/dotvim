" Calculate the body location
let [s:line, s:col] = searchpos('^$', '')
if s:line == 0
	" Can't find the correct path, get to the bottom
	let s:line = getline('$')
	let s:col = 1
endif

" Get to the correct line and open a new line below
call feedkeys(s:line.'Go', 'n')
