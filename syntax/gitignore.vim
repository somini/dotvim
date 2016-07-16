" Vim syntax file
" Language:	Gitignore files
" Maintainer:	somini <somini@users.noreply.github.com>
" Last Change:	2016-07-16

if exists("b:current_syntax")
  finish
endif

syntax match gitignoreComment "^#.*"
syntax match gitignoreInvert "^!"

syntax match gitignoreErrAsteriks "\*\{3,\}"

hi def link gitignoreComment Comment
hi def link gitignoreNormal Function

hi def link gitignoreErrAsteriks Error

let b:current_syntax = "gitignore"
