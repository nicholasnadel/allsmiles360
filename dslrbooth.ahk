
IfWinExist, dslrBooth
	WinActivate dslrBooth
	else
	run, C:\Program Files (x86)\dslrBooth\dslrBooth.exe
WinWaitActive dslrBooth