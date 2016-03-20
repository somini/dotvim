function! s:RunCurrentProject()
	"Sane defaults
	let l:vim_cmd = 'RustRun'
	if filereadable('Cargo.toml') "Assume pwd is correct
		let l:vim_cmd = 'Start -wait=always cargo run'
	endif
	execute l:vim_cmd
endfunction
function! s:BuildCurrentProject()
	"Sane defaults
	let l:vim_cmd = 'Start rustc'
endfunction
" r: Run current project/file
nnoremap <silent> <buffer> <LocalLeader>r :call <SID>RunCurrentProject()<CR>
