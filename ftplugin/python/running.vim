function! s:RunCurrentFileInteractive()
	let l:cmd = 'python' "Sane default
	if getline(1) =~# '\V\^#!'
		" Use the shebang
		let l:cmd = getline(1)[2:]
	endif
	let l:cmd .= ' -i '
	execute 'Start ' . l:cmd . shellescape('%')
endfunction
" R: Run current file, interactively
nnoremap <silent> <LocalLeader>R :call <SID>RunCurrentFileInteractive()<CR>
