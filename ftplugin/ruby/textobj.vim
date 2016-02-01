call textobj#user#map('ruby', {
			\   'any': {
			\     'select-a': '<buffer> a<LocalLeader><LocalLeader>',
			\     'select-i': '<buffer> i<LocalLeader><LocalLeader>',
			\   },
			\   'function': {
			\     'select-a': '<buffer> a<LocalLeader>f',
			\     'select-i': '<buffer> i<LocalLeader>f',
			\   },
			\   'class': {
			\     'select-a': '<buffer> a<LocalLeader>c',
			\     'select-i': '<buffer> i<LocalLeader>c',
			\   },
			\ })
