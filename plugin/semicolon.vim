" Helper Functions
function! s:GetCurrentSyntaxName()
	return synIDattr(synID(line("."), col("."), 1), "name")
endfunction

" The whole point
function! s:InsertKey(key)
	let l:var = 'g:semicolon_ft_'.&ft
	if exists(l:var)
		let l:cursyn = s:GetCurrentSyntaxName()
		execute 'let l:syngroups = '.l:var
		if index(l:syngroups, l:cursyn) != -1
			" Do nothing
			return a:key
		endif
	endif
	if getline('.') =~# a:key.'$'
		" Don't repeat semicolons
		return a:key
	else
		" Get to the end of the line and add a semicolon
		return "\<C-o>$".a:key
	endif
endfunction
inoremap <expr> <Plug>InsertSemicolon <SID>InsertKey(';')

" Filetype-specific configuration
let g:semicolon_ft_javascript = ['javaScriptStringS', 'javaScriptStringD', 'javaScriptLineComment']
"TODO: Disable for Rust inside []

" The all-important mapping
augroup semicolon | autocmd!
	autocmd FileType javascript,rust imap <buffer> ; <Plug>InsertSemicolon
augroup END
