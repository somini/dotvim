" Alias the movement commands for usual operations
nmap <buffer> <silent> <nowait> j <C-n>
nmap <buffer> <silent> <nowait> k <C-p>
" h to stage/reset
nmap <buffer> <silent> <nowait> h -
" l to open file and close the status buffer
" L to just open it
nmap <buffer> <silent> <nowait> l <CR>:pclose<CR>
nmap <buffer> <silent> <nowait> L <CR>
