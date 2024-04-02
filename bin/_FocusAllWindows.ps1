$wshell = New-Object -ComObject wscript.shell

Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | ForEach({
	Write-Host $_.MainWindowTitle -NoNewLine
	Write-Host ": " -NoNewLine
	$wshell.AppActivate($_.MainWindowTitle)
})

