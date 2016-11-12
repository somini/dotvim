function! s:RunCurrentFile(interactive)
	"Sane defaults
	let l:cmd = 'python'
	let l:start_opt = ''

	if getline(1) =~# '\V\^#!'
		" Use the shebang
		let l:cmd = getline(1)[2:]
	else
		if exists('b:python_exe')
			" Allow forcing python version, if the file doesn't require it
			let l:cmd = substitute(l:cmd, 'python$', b:python_exe, '')
		endif
	endif
	if a:interactive
		let l:cmd .= ' -i '
		let l:start_opt .= ' -wait=never '
	else
		let l:cmd .= ' '
		let l:start_opt .= ' -wait=always '
	endif
	execute 'Start' . l:start_opt . l:cmd . shellescape('%')
endfunction
" r: Run current file (works even when there's no shebang)
" R: Run current file, interactively
nnoremap <silent> <buffer> <LocalLeader>r :call <SID>RunCurrentFile(0)<CR>
nnoremap <silent> <buffer> <LocalLeader>R :call <SID>RunCurrentFile(1)<CR>
