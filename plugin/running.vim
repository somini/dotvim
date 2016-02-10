function! s:RunCurrentFile()
	let l:file = shellescape(expand('%:p'))
	execute 'Start -wait=always '.l:file
endfunction
" r: Run current file
nnoremap <silent> <LocalLeader>r :call <SID>RunCurrentFile()<CR>
