" somini.gvimrc

" Appearance {{{
"}}}

" No menus nor toolbars {{{
set guioptions-=m guioptions-=T
set go-=r go-=R go-=l go-=L go-=b "No scrollbars
set guioptions-=t "Tear-off menus are too oldskool
"}}}

" Toggle menu and toolbar {{{
nnoremap <silent> <S-F1> :call SetToggle('guioptions','m')<CR>
nnoremap <silent> <S-F2> :call SetToggle('guioptions','T')<CR>
"}}}

" Modeline {{{
" vim:ft=vim:ts=2:sw=2:fdm=marker
"}}}
