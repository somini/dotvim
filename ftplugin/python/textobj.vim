call textobj#user#map('python', {
			\   'class': {
			\     'select-a': '<buffer> a<LocalLeader>c',
			\     'select-i': '<buffer> i<LocalLeader>c',
			\     'move-n': '<buffer> ]<LocalLeader>c',
			\     'move-p': '<buffer> [<LocalLeader>c',
			\   },
			\   'function': {
			\     'select-a': '<buffer> a<LocalLeader>f',
			\     'select-i': '<buffer> i<LocalLeader>f',
			\     'move-n': '<buffer> ]<LocalLeader>f',
			\     'move-p': '<buffer>  [<LocalLeader>f',
			\   }
			\ })
