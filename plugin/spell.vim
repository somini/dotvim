function! s:globFiles(basedir,names)
	let l:res = []
	for l:name in a:names
		let l:res = extend(l:res,(glob(a:basedir.'/'.l:name,0,1)))
	endfor
	return l:res
endfunction

function! s:fill(variable, array)
	if !empty(a:array)
		for l:e in a:array
			execute 'set '.a:variable.'+='.escape(l:e,',')
		endfor
	endif
endfunction

function! SetSpellingConfigurationExtra()
	" Naïve version, only catches the first language
	let l:regex_language = '\v\c^(\w{2})_(\w{2})'
	let l:lang = tolower( substitute(&spelllang,l:regex_language,'\1','') )
	let l:lang_region = toupper( substitute(&spelllang,l:regex_language,'\2','') )
	if &verbose >= 5
		echom 'Language: '.l:lang.' Region: '.l:lang_region
	endif

	" Initialize
	set dictionary= thesaurus=

	if &spell
		" Dictionaries
		let l:dicts = s:globFiles(g:user_dir.'/spell/dictionaries', [
					\ '*.'.l:lang.'_'.l:lang_region,
					\ '*.'.l:lang,
					\ ])
		call s:fill('dictionary',l:dicts)

		" Thesaurus
		let l:thes = s:globFiles(g:user_dir.'/spell/thesaurus', [
					\ '*.'.l:lang.'_'.l:lang_region,
					\ '*.'.l:lang,
					\ ])
		call s:fill('thesaurus', l:thes)
	endif
endfunction
autocmd User SpellingLanguageChange call SetSpellingConfigurationExtra()

" vim: ts=2 sw=2
