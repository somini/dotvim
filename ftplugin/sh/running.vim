function! s:RunCurrentFileInteractive()
	let l:file = shellescape(expand('%:p'))
	let shebang = getline(1)
	if shebang =~# '^\#\!'
		let l:shell = shebang[2:]
	else
		let l:shell = 'bash' "Fallback
	endif
	if l:shell =~# '\<bash\>'
		let l:opt = '--rcfile'
	else
		echom 'Shell Unsupported: '.l:shell
		return
	endif
	execute 'Start -wait=never '.l:shell.' '.l:opt.' '.l:file
endfunction
" R: Run current file, interactively
nnoremap <silent> <buffer> <LocalLeader>R :call <SID>RunCurrentFileInteractive()<CR>
