" after/plugin/my_tabular_commands.vim
" Provides extra :Tabularize commands

if !exists(':Tabularize')
	finish " Give up here; the Tabular plugin musn't have been loaded
endif

" Make line wrapping possible by resetting the 'cpo' option, first saving it
let s:save_cpo = &cpo
set cpo&vim

" Common patterns
AddTabularPattern! single_space /\ /

" Restore the saved value of 'cpo'
let &cpo = s:save_cpo
unlet s:save_cpo
