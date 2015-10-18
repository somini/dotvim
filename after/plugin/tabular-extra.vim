" after/plugin/my_tabular_commands.vim
" Provides extra :Tabularize commands

if !exists(':Tabularize')
	finish " Give up here; the Tabular plugin musn't have been loaded
endif

" Make line wrapping possible by resetting the 'cpo' option, first saving it
let s:save_cpo = &cpo
set cpo&vim

" Common patterns
AddTabularPattern! single_space         /\ /
AddTabularPattern! commas               /,/l0l1
AddTabularPattern! string_double_quotes /".*"/l0l1l0
AddTabularPattern! first_fslash         /^[^\/]*\zs\//l1l0l0

AddTabularPattern! words_first_1        /^\s\+\zs\S\+\ze/
AddTabularPattern! words_first_2        /^\s\+\(\S\+\s\+\)\?\zs\S\+\ze/
" Restore the saved value of 'cpo'
let &cpo = s:save_cpo
unlet s:save_cpo
