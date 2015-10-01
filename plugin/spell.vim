function! SetSpellingConfigurationExtra()
	" Naïve version, only catches the first language
	" TODO: Too much repeated code, keep this DRY
	let l:regex_language = '\v\c^(\w{2})_(\w{2})'
	let l:lang = tolower( substitute(&spelllang,l:regex_language,'\1','') )
	let l:lang_region = toupper( substitute(&spelllang,l:regex_language,'\2','') )

	" Dictionaries
	set dictionary=
	let l:dicts = []
	let l:dicts = extend(l:dicts,(glob(g:user_dir.'/spell/dictionaries/*.'.l:lang.'_'.l:lang_region,0,1)))
	let l:dicts = extend(l:dicts,(glob(g:user_dir.'/spell/dictionaries/*.'.l:lang,0,1)))
	if !empty(l:dicts)
		for l:var in l:dicts
			execute 'set dictionary+='.escape(l:var,',')
		endfor
	endif
	" Thesaurus
	set thesaurus=
	let l:thes = []
	let l:thes = extend(l:thes,(glob(g:user_dir.'/spell/thesaurus/*.'.l:lang.'_'.l:lang_region,0,1)))
	let l:thes = extend(l:thes,(glob(g:user_dir.'/spell/thesaurus/*.'.l:lang,0,1)))
	if !empty(l:thes)
		for l:var in l:thes
			execute 'set thesaurus+='.escape(l:var,',')
		endfor
	endif

endfunction
autocmd User SpellingLanguageChange call SetSpellingConfigurationExtra()

" vim: ts=2 sw=2
