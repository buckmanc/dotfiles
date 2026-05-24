function Invoke-Starship-PreCommand {
        $host.ui.Write("`e]0; ` $((Get-Item $pwd ).Name) `a")
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
        Invoke-Expression (&starship init powershell)
}
