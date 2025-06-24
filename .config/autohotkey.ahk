#Warn		; enable warnings
#SingleInstance Force

; disable non-numlock, scroll lock, and insert
SetNumLockState "AlwaysOn"
SetScrollLockState "AlwaysOff"
Insert::return

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

		Send "{Alt}at{Alt}at"					; reset filters
		Send "{Ctrl Down}a{Ctrl Up}"			; select all
		Send "{Alt}hh{Right}{Enter}"			; black background
		Send "{Alt}hfc{Down 4}{Right 3}{Enter}"	; blue text
		Send "{Ctrl Down}{Home}{Ctrl Up}"		; select first cell
		Send "{Up}{Shift Down} {Shift Up}"		; select top row
		Send "{Ctrl Down}b{Ctrl Up}"			; bold
		Send "{Ctrl Down}{Home}{Ctrl Up}"		; select first cell
		Send "{Alt}wfr"							; freeze top row
		Send "{Alt}at"							; filter
	}
	else if WinActive("ahk_exe ssms.exe")
	{
		KeyWait "Control"
		KeyWait "Shift"

		Send "^d"		; results to grid (fixes accidental ctrl+t)
		Send "^+r"		; refresh auto complete cache
		Send "^r"		; hide results window
		Send "{Alt}w1"	; refocus the last window (gets out of stupid panes)
	}
	else if WinActive("ahk_exe webfishing.exe")
	{
		; fish faster
		click 50 
	}
	else if WinActive("ahk_exe discord.exe") or WinActive("ahk_exe msteams.exe")
	{
		KeyWait "Control"
		KeyWait "Shift"

		; local mute shortcut, instead of the global but barely supported shortcut
		Send "{Ctrl Down}{Shift Down}m{Ctrl Up}{Shift Up}"
	}
	else if WinActive("ahk_exe retroarch.exe")
	{
		; hadouken!
		Send "{Down down}{Right down}{Down up}{Right up}a"
	}
	else if WinActive("ahk_exe chrome.exe")
	{
		KeyWait "Control"
		KeyWait "Shift"

		; move tabs between windows
		Send "+!t"				; focus the first item on the toolbar
		Send "{F6}"				; select the current tab
		Send "{Apps}m{Right}"	; menu, move to window, list windows
		; pick the window
		if WinActive("ill") or WinActive("sic")
		{
			Send "o"
		}
		else if WinActive("ork")
		{
			Send "i"
		}
		else
		{
			Send "{Down}"
		}

		Send "{Enter}"			; select
	}
	else if WinActive("ahk_exe spotify.exe")
	{
		KeyWait "Control"
		KeyWait "Shift"

		; Send "!+b"		; like the current song DO NOT USE as it unlikes liked songs too
		Send "!+j"		; go to now playing
	}
	else
	{
		; otherwise, reload this file
		Reload
		TrayTip "reloaded ahk file", "ahk", "Iconi Mute"
	}
}

; convert ctrl+shift+p to ctrl+shift+n in chrome
; coz ctrl+shift+p *should* be new private tab
; not print
; especially when ctrl+p, the universal print shortcut, is already in effect
^+P::
{
	if WinActive("ahk_exe chrome.exe")
	{
		KeyWait "Control"
		KeyWait "Shift"

		Send "^+n"
	}
}

; some spotify controls for macropads
F20::RunBash '"$HOME/bin/xspot" --device auto'
F21::RunBash '"$HOME/bin/xspot" --play-toggle'
F22::RunBash '"$HOME/bin/xspot" --skip-next'
F23::RunBash '"$HOME/bin/xspot" --skip-previous'
F24::RunBash '"$HOME/bin/xspot" --like'
