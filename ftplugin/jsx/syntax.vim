" Run this super-special wrapper on React projects
" It's fast enough to run on active mode
" But check it if exists first
if !executable(g:syntastic_javascript_jsxhint_exec)
	echohl WarningMsg
	echo 'Install "https://github.com/jaxbot/syntastic-react" for an ideal React-Vim pairing'
	echo 'Or start (g)Vim from the correct shell with a funky $PATH'
	echohl None
	finish
endif

let b:syntastic_checkers = ['jsxhint']
let b:syntastic_mode = 'active'
