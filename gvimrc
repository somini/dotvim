" somini.gvimrc

" Appearance {{{
" TODO: Single command that takes a number
command! FontSizeIncrease let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)+1', '')
command! FontSizeDecrease let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)-1', '')
"}}}

" Data Safety and Managing {{{
" Only on GUI vim, on terminals <C-s> will suspend the terminal
inoremap <silent> <C-s> <C-o>:write<CR>
"}}}

" Mouse {{{
set mousehide "Hide mouse when typing
" }}}

" Workarounds {{{
" Don't close windows by accident
nmap <C-w><C-c> <C-c>
" Map ALT to whatever you want
set winaltkeys=no
"}}}

" No menus nor toolbars {{{
set guioptions-=m guioptions-=T
set go-=r go-=R go-=l go-=L go-=b "No scrollbars
set guioptions-=t "Tear-off menus are too oldskool
set guioptions+=c " Don't use graphical prompts
"}}}

" Toggle menu and toolbar {{{
nnoremap <silent> <M-F1> :call SetToggle('guioptions','m')<CR>
nnoremap <silent> <M-F2> :call SetToggle('guioptions','T')<CR>
"}}}

" Modeline {{{
" vim:ft=vim:ts=2:sw=2:fdm=marker
"}}}
