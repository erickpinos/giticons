# Run as admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator"
    Break
}

# Paths to delete
$basePath = "HKCU:\Software\Classes"
$paths = @(
    "$basePath\Directory\Background\shellex\ContextMenuHandlers\GitShell",
    "$basePath\Directory\shellex\ContextMenuHandlers\GitShell",
    "$basePath\Directory\shellex\ContextMenuHandlers\GitShell\.git"
)

# Delete each if it exists
foreach ($path in $paths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force
    }
}

Write-Host "Git context menu entries removed for current user."
Write-Host "Restart File Explorer to apply changes."
