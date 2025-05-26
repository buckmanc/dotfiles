#Warn		; enable warnings
#SingleInstance Force

RunBash(cmd)
{
	Run '"' . A_ProgramFiles . '\Git\usr\bin\bash.exe" --noprofile --norc -c "export PATH=\"/usr/bin:$PATH\" && ' . cmd . '"', , "Min"
}

SetNumLockState "AlwaysOn"
SetScrollLockState "AlwaysOff"
Insert::return
F19::Reload
; some spotify controls for macropads
F20::RunBash '"$HOME/bin/xspot" --device auto'
F21::RunBash '"$HOME/bin/xspot" --play-toggle'
F22::RunBash '"$HOME/bin/xspot" --skip-next'
F23::RunBash '"$HOME/bin/xspot" --skip-previous'
F24::RunBash '"$HOME/bin/xspot" --like'
