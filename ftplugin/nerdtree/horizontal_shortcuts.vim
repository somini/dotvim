" Use this convoluted thing to make sure there's no mapping conflicts
" TODO: NERDTreeMapping API, but this is clean enough methinks
execute 'nmap <buffer> <silent> <nowait> l ' . maparg('<CR>','n')
execute 'nmap <buffer> <silent> <nowait> h ' . maparg('x','n')
