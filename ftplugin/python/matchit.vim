" Configuration
let b:match_ignorecase = 0 " Case sensitive
let b:match_skip = 's:Comment\|String'
" Matching pairs/triplets
let b:match_words = ''
let b:match_words .= '\<if\>:\<elif\>:\<else\>,'
let b:match_words .= '\<def\>:\<return\>,'
let b:match_words .= '\<def\>:\<yield\>,'
let b:match_words .= '\<try\>:\<except\>:\<finally\>,'
