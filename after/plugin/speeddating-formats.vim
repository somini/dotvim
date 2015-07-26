" Chack if SpeedDating is installed
if !exists(':SpeedDatingFomat')
	finish
endif

" The One True Date Format
SpeedDatingFormat %d%[/-]%m%1%Y
