#Warn		; enable warnings
#SingleInstance Force

; disable non-numlock, scroll lock, and insert
SetNumLockState "AlwaysOn"
SetScrollLockState "AlwaysOff"
Insert::return
TraySetIcon(EnvGet("UserProfile") . '/.config/assets/icons/ico/autohotkey.ico')

RunBash(cmd)
{
	; vim syntax highlighting breaks down on the single/double quotes here
	; keep the window open if errors occur
	; Run '"' . A_ProgramFiles . '\Git\usr\bin\bash.exe" --noprofile --norc -c "export PATH=\"/usr/bin:$PATH\" && ' . cmd . ' || read -rs -n1 -p \"press any key to continue\""', , "Min"
	Run '"' . A_ProgramFiles . '\Git\usr\bin\bash.exe" --noprofile --norc -c "export PATH=\"/usr/bin:$PATH\" && ' . cmd . ' &> \"/tmp/ahk_toast\""', , "Hide"

	; check for a toast temp file written by the above command
	SetTimer ToastTimerFunc, 500

	ToastTimerFunc()
	{
		ToastPath := EnvGet("TEMP") . '/1/ahk_toast'
		ToastPathAlt := EnvGet("TEMP") . '/ahk_toast'

		; crappy yet concise fringe case coverage
		if FileExist(ToastPathAlt)
		{
			ToastPath := ToastPathAlt
		}

		if FileExist(ToastPath)
		{
			; disable this check
			SetTimer ToastTimerFunc, 0
			ToastText := FileRead(ToastPath)
			FileDelete(ToastPath)
			; toast
			TrayTip ToastText, "", "Mute"
		}
	}
}

; window-dependant magic hotkey
; this DOES EAT ctrl+shift+g!
^+G::
{
	; unpress ctrl and shift from the hotkey
	; "blind" mode ensures that the keys are not restored
	Send "{Blind}{Ctrl Up}{Shift Up}"

	if WinActive("ahk_exe EXCEL.EXE")
	{
		; format Excel spreadsheets

		Send "{Alt}at{Alt}at"					; reset filters
		Send "{Ctrl Down}a{Ctrl Up}"			; select all
		Send "{Ctrl Down}a{Ctrl Up}"			; select *all*
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
		Send "^d"		; results to grid (fixes accidental ctrl+t)
		Send "^+r"		; refresh auto complete cache
		Send "^r"		; hide results window
		Send "{Alt}w1"	; refocus the last window (gets out of stupid panes)
	}
	else if WinActive("ahk_exe webfishing.exe")
	{
		; fish faster
		; still untested
		click 50 
	}
	else if WinActive("ahk_exe discord.exe") or WinActive("ahk_exe msteams.exe")
	{
		; local mute shortcut, instead of the global but barely supported shortcut
		Send "{Ctrl Down}{Shift Down}m{Ctrl Up}{Shift Up}"
	}
	else if WinActive("ahk_exe retroarch.exe")
	{
		; hadouken!
		; still untested
		Send "{Down down}{Right down}{Down up}{Right up}a"
	}
	; never worked right
	; else if WinActive("ahk_exe chrome.exe")
	; {
	; 	; move tabs between windows
	; 	Send "+!t"				; focus the first item on the toolbar
	; 	Send "{F6}"				; select the current tab
	; 	Send "{Apps}m{Right}"	; menu, move to window, list windows
    ;
	; 	; pick the window
	; 	if WinActive("ill") or WinActive("sic")
	; 	{
	; 		Send "o"
	; 	}
	; 	else if WinActive("ork")
	; 	{
	; 		Send "i"
	; 	}
	; 	else
	; 	{
	; 		Send "{Down}"
	; 	}
    ;
	; 	Send "{Enter}"			; select
	; }
	else if WinActive("ahk_exe spotify.exe")
	{
		; Send "!+b"		; like the current song DO NOT USE as it unlikes liked songs too
		Send "!+j"		; go to now playing
	}
	else if WinActive("ahk_exe msteams.exe")
	{
		Send "^+H"		; hang up
	}
	else
	{
		; otherwise, reload this file
		Reload
		TrayTip "reloaded ahk file", "", "Mute"
	}
}

; convert ctrl+shift+p to ctrl+shift+n in chrome
; coz ctrl+shift+p *should* be new private tab
; not print
; especially when ctrl+p, the universal print shortcut, is already in effect
#HotIf WinActive("ahk_exe chrome.exe")
^+P::
{
	; unpress ctrl and shift from the hotkey
	; "blind" mode ensures that the keys are not restored
	Send "{Blind}{Ctrl Up}{Shift Up}"

	Send "^+n"
}
#HotIf

#HotIf WinActive("ahk_exe devenv.exe") or WinActive("ahk_exe ssms.exe")
F1::
F4::
Browser_Home::
Browser_Search::
{
	TrayTip "blocked", "", "Mute"
	return
}
#HotIf

; some spotify controls for macropads
!#F1::RunBash '\"$HOME/bin/xspot\" --like'
!#F2::RunBash '\"$HOME/bin/xspot\" --device auto'
