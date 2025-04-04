# Desktop.ini template for folder customization
$desktopIniContent = @"
[.ShellClassInfo]
IconResource=%SystemRoot%\System32\SHELL32.dll,147
IconFile=%SystemRoot%\System32\SHELL32.dll
IconIndex=147
"@

# Function to set folder icon using desktop.ini
function Set-FolderIcon {
    param (
        [string]$folderPath
    )
    
    try {
        # Create or update desktop.ini
        $desktopIniPath = Join-Path $folderPath "desktop.ini"
        $desktopIniContent | Out-File -FilePath $desktopIniPath -Encoding unicode -Force
        
        # Set file attributes
        $desktopIniFile = Get-Item $desktopIniPath -Force
        $desktopIniFile.Attributes = [System.IO.FileAttributes]::Hidden + [System.IO.FileAttributes]::System + [System.IO.FileAttributes]::Archive
        
        # Set folder attributes
        $folder = Get-Item $folderPath -Force
        $folder.Attributes = $folder.Attributes -bor [System.IO.FileAttributes]::ReadOnly
        
        Write-Host "Icon set successfully for: $folderPath"
    }
    catch {
        Write-Error "Failed to set icon for $folderPath. Error: $_"
    }
}

# Get all .git folders in subdirectories with max depth of 3
$maxDepth = 3
$currentPath = (Get-Location).Path
$gitFolders = @()

# Manual recursive search with depth control
function Get-GitFoldersWithDepth {
    param (
        [string]$path,
        [int]$currentDepth
    )
    
    if ($currentDepth -gt $maxDepth) {
        return
    }
    
    # Get immediate subdirectories
    $dirs = Get-ChildItem -Path $path -Directory -Force -ErrorAction SilentlyContinue
    
    foreach ($dir in $dirs) {
        # Check for .git folder
        if ($dir.Name -eq ".git") {
            $gitFolders += $dir
        }
        
        # Recurse into subdirectories
        Get-GitFoldersWithDepth -path $dir.FullName -currentDepth ($currentDepth + 1)
    }
}

# Start the search from depth 1
Get-GitFoldersWithDepth -path $currentPath -currentDepth 1

# Store processed parent paths to avoid duplicates
$processedPaths = @{}

foreach ($gitFolder in $gitFolders) {
    # Get the parent of the folder containing .git
    $parentOfGitFolder = $gitFolder.Parent.Parent.FullName
    
    # Skip if we've already processed this path or if it's null
    if ($null -eq $parentOfGitFolder -or $processedPaths.ContainsKey($parentOfGitFolder)) {
        continue
    }
    
    # Add to processed paths
    $processedPaths[$parentOfGitFolder] = $true
    
    # Set the icon for the parent folder
    Set-FolderIcon -folderPath $parentOfGitFolder
}

Write-Host "Script completed. Icons have been set for all parent folders containing git repositories (up to depth $maxDepth)." 