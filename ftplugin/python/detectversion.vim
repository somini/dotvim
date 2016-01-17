" Make sure syntastic is loaded
if !exists('g:loaded_syntastic_util_autoload')
	finish
endif

if syntastic#util#parseShebang()['exe'] =~# 'python3$'
	let b:syntastic_python_python_exec = 'python3'
	set omnifunc=python3complete#Complete
endif
