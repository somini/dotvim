function! s:RunCurrentFile()
	source %
endfunction
" r: "Run" (source) current file
nnoremap <silent> <buffer> <LocalLeader>r :call <SID>RunCurrentFile()<CR>
