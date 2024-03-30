param($processName = $(throw "need process name"), $priority = "idle")

get-process -processname $processname | foreach { $_.PriorityClass = $priority }
