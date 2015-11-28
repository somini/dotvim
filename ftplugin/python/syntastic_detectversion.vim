let shebang = getline(1)
" Lax regex, to work on bare binary and env and whatever
if shebang =~# '\<python3\>'
	let p_version = '3'
else
	let p_version = ''
endif

let b:syntastic_python_python_exec = get(g:, 'syntastic_python_python_exec', 'python') . p_version
