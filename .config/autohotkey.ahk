#Warn		; enable warnings
#SingleInstance Force

RunBash(cmd)
{
	Run '"' . A_ProgramFiles . '\Git\usr\bin\bash.exe" --noprofile --norc -c "export PATH=\"/usr/bin:$PATH\" && ' . cmd . '"', , "Min"
}

; window-dependant magic hotkey
^+G::
F19::
{
	if WinActive("ahk_exe EXCEL.EXE")
	{
		KeyWait "Control"
		KeyWait "Shift"

		; format Excel spreadsheets
		Send "{Alt}at{Alt}at"
		Send "{Ctrl Down}a{Ctrl Up}"
		Send "{Alt}hh{Right}{Enter}"
		Send "{Alt}hfc{Down 4}{Right 3}{Enter}"
		Send "{Ctrl Down}{Home}{Ctrl Up}"
		Send "{Alt}wfr"
		Send "{Alt}at"
	}
	; else if WinActive("ahk_exe EXCEL.EXE")
	; {
    ;
	; }
	else
	{
		; otherwise, reload this file
		Reload
	}
}

SetNumLockState "AlwaysOn"
SetScrollLockState "AlwaysOff"
Insert::return
; some spotify controls for macropads
F20::RunBash '"$HOME/bin/xspot" --device auto'
F21::RunBash '"$HOME/bin/xspot" --play-toggle'
F22::RunBash '"$HOME/bin/xspot" --skip-next'
F23::RunBash '"$HOME/bin/xspot" --skip-previous'
F24::RunBash '"$HOME/bin/xspot" --like'
