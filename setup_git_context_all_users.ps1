# Run this script as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator"
    Break
}

# Path to Git icon (using the default Git icon)
$gitIconPath = "C:\Program Files\Git\git-bash.exe,0"

# Create registry entries for Git repository folders
$registryPath = "HKCR:\Directory\Background\shellex\ContextMenuHandlers\GitShell"
$gitShellPath = "C:\Program Files\Git\git-bash.exe"

# Create the GitShell key if it doesn't exist
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the default value for the GitShell key
Set-ItemProperty -Path $registryPath -Name "(Default)" -Value "{B1A9A0A0-0A0A-0A0A-0A0A-0A0A0A0A0A0A}" -Type String

# Create the GitShell command
$gitShellCommand = "`"$gitShellPath`" --no-needs-console --hide --no-cd --command=post-install"

# Set the command
Set-ItemProperty -Path $registryPath -Name "Command" -Value $gitShellCommand -Type String

# Create registry entry for Git repository folders
$gitRepoPath = "HKCR:\Directory\shellex\ContextMenuHandlers\GitShell"
if (!(Test-Path $gitRepoPath)) {
    New-Item -Path $gitRepoPath -Force | Out-Null
}

# Set the default value for Git repository folders
Set-ItemProperty -Path $gitRepoPath -Name "(Default)" -Value "{B1A9A0A0-0A0A-0A0A-0A0A-0A0A0A0A0A0A}" -Type String

# Create the Git repository command
$gitRepoCommand = "`"$gitShellPath`" --no-needs-console --hide --no-cd --command=post-install"

# Set the command for Git repositories
Set-ItemProperty -Path $gitRepoPath -Name "Command" -Value $gitRepoCommand -Type String

# Create registry entry for .git folders
$gitFolderPath = "HKCR:\Directory\shellex\ContextMenuHandlers\GitShell\.git"
if (!(Test-Path $gitFolderPath)) {
    New-Item -Path $gitFolderPath -Force | Out-Null
}

# Set the default value for .git folders
Set-ItemProperty -Path $gitFolderPath -Name "(Default)" -Value "{B1A9A0A0-0A0A-0A0A-0A0A-0A0A0A0A0A0A}" -Type String

# Create the .git folder command
$gitFolderCommand = "`"$gitShellPath`" --no-needs-console --hide --no-cd --command=post-install"

# Set the command for .git folders
Set-ItemProperty -Path $gitFolderPath -Name "Command" -Value $gitFolderCommand -Type String

Write-Host "Git icons have been configured successfully!"
Write-Host "You may need to restart File Explorer for the changes to take effect." 