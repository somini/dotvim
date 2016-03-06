function! s:RunCurrentFile(interactive)
	"Sane defaults
	let l:cmd = 'racket'
	let l:start_opt = ''

	if getline(1) =~# '\V\^#!'
		" Use the shebang
		let l:cmd = getline(1)[2:]
	endif
	if a:interactive
		let l:cmd .= ' -l xrepl -i -u '
		let l:start_opt .= ' -wait=never '
	else
		let l:cmd .= ' '
		let l:start_opt .= ' -wait=always '
	endif
	execute 'Start' . l:start_opt . l:cmd . shellescape('%')
endfunction
" r: Run current file (works even when there's no shebang)
" R: Run current file, with a XREPL
nnoremap <silent> <buffer> <LocalLeader>r :call <SID>RunCurrentFile(0)<CR>
nnoremap <silent> <buffer> <LocalLeader>R :call <SID>RunCurrentFile(1)<CR>

