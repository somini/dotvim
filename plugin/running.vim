function! s:RunCurrentFile()
	execute "Start -wait=always ./".shellescape('%')
endfunction
" r: Run current file
nnoremap <silent> <LocalLeader>r :call <SID>RunCurrentFile()<CR>
