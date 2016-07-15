augroup ftdetect_fontconfigxml | autocmd!
	autocmd BufRead,BufNewFile /etc/fonts/fonts.conf set filetype=fontconfig.xml
	autocmd BufRead,BufNewFile /etc/fonts/conf.d/*.conf set filetype=fontconfig.xml
	execute 'autocmd BufRead,BufNewFile' expand('~/.config/fontconfig/fonts.conf') 'setfiletype fontconfig.xml'
	execute 'autocmd BufRead,BufNewFile' expand('~/.config/fontconfig/conf.d/').'*.conf' 'setfiletype fontconfig.xml'
augroup END
