# Run this script as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator"
    Break
}

# Path to Git icon and executable
$gitIconPath = "C:\Program Files\Git\git-bash.exe,0"
$gitShellPath = "C:\Program Files\Git\git-bash.exe"
$guid = "{B1A9A0A0-0A0A-0A0A-0A0A-0A0A0A0A0A0A}"
$command = "`"$gitShellPath`" --no-needs-console --hide --no-cd --command=post-install"

# Paths under HKCU
$basePath = "HKCU:\Software\Classes"
$backgroundPath = "$basePath\Directory\Background\shellex\ContextMenuHandlers\GitShell"
$folderPath     = "$basePath\Directory\shellex\ContextMenuHandlers\GitShell"
$dotGitPath     = "$basePath\Directory\shellex\ContextMenuHandlers\GitShell\.git"

# Function to create handler
function Add-GitShellHandler {
    param ($path)
    if (!(Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
    Set-ItemProperty -Path $path -Name "(Default)" -Value $guid -Type String
    Set-ItemProperty -Path $path -Name "Command" -Value $command -Type String
}

# Create registry entries
Add-GitShellHandler -path $backgroundPath
Add-GitShellHandler -path $folderPath
Add-GitShellHandler -path $dotGitPath

Write-Host "Git icons configured for current user only!"
Write-Host "Restart File Explorer to apply changes."
