if exists(':SnipMateLoadScope') != 2
	finish
endif

if exists('$DJANGO_SETTINGS_MODULE')
	SnipMateLoadScope django
endif
