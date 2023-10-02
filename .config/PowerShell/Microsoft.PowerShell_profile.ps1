function Invoke-Starship-PreCommand {
        $host.ui.Write("`e]0; ` $((Get-Item $pwd ).Name) `a")
}

Invoke-Expression (&starship init powershell)
