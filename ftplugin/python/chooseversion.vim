function! s:setversion(version)
	" Coerce argument to number
	let b:python_version = 0 + a:version
	call s:onchange()
endfunction

function! s:onchange()
	let b:python_exe = 'python'
	if b:python_version == 2
		if executable('python2')
			let b:python_exe = 'python2'
		endif
		setlocal omnifunc=pythoncomplete#Complete
	elseif b:python_version == 3
		if executable('python3')
			let b:python_exe = 'python3'
		endif
		setlocal omnifunc=python3complete#Complete
	else
		echom 'Python Version: Unknown'
		unlet! b:python_exe
		return
	endif
	let b:syntastic_python_python_exec = b:python_exe
endfunction

function! s:autodetect()
	let l:buf = bufnr('')
	let l:shebang = syntastic#util#parseShebang(l:buf)['exe']
	if l:shebang == ''
		" Get the default from the exe named "python"
		return substitute(systemlist('python --version')[0], '^Python \([23]\).*', '\1', '')
	else
		if l:shebang =~# 'python3$'
			return 3
		else
			return 2
		endif
	endif
endfunction

if !exists('b:python_version')
	" Auto-detect the current file version
	let b:python_version = s:autodetect()
endif
call s:onchange()

function! PySetVersion(a)
	call s:setversion(a:a)
endfunction
function! PyGetVersion()
	return b:python_version
endfunction
