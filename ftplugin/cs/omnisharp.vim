" Contextual code actions (uses CtrlP)
" Includes visual mode
nnoremap <buffer> <LocalLeader><Space> :OmniSharpGetCodeActions<CR>
vnoremap <buffer> <LocalLeader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Refactor variables
" The second one skips the dialog
nnoremap <buffer> <LocalLeader>r :OmniSharpRename<CR>
nnoremap <buffer> <LocalLeader>R :call OmniSharp#RenameTo('')<Left><Left>
