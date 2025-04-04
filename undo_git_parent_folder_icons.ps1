# Function to restore default folder settings
function Restore-DefaultFolder {
    param (
        [string]$folderPath
    )
    
    try {
        # Path to desktop.ini
        $desktopIniPath = Join-Path $folderPath "desktop.ini"
        
        # Check if desktop.ini exists
        if (Test-Path $desktopIniPath -PathType Leaf) {
            # Remove the ReadOnly attribute from the folder to allow desktop.ini deletion
            $folder = Get-Item $folderPath -Force
            $folder.Attributes = $folder.Attributes -band (-bnot [System.IO.FileAttributes]::ReadOnly)
            
            # Delete desktop.ini
            Remove-Item $desktopIniPath -Force
            Write-Host "Restored default folder icon for: $folderPath"
        }
    }
    catch {
        Write-Error "Failed to restore default settings for $folderPath. Error: $_"
    }
}

# Get all .git folders in subdirectories
$gitFolders = Get-ChildItem -Path . -Directory -Recurse -Force -Hidden | 
    Where-Object { $_.Name -eq ".git" }

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
    
    # Restore default folder settings
    Restore-DefaultFolder -folderPath $parentOfGitFolder
}

Write-Host "Script completed. Default folder icons have been restored for all previously modified folders." 