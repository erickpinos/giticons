$gitIcon = "C:\Program Files\Git\mingw64\share\git\git-for-windows.ico"
$basePath = Get-Location
$maxDepth = 3
$counter = 0

function Get-Folders {
    param ($path, $depth)
    if ($depth -le 0) { return }
    Write-Host "Scanning: $path"
    Get-ChildItem -Path $path -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
        $_
        Get-Folders -path $_.FullName -depth ($depth - 1)
    }
}

$folders = Get-Folders -path $basePath -depth $maxDepth | Where-Object {
    Test-Path "$($_.FullName)\.git"
}

foreach ($repo in $folders) {
    $counter++
    Write-Host "[$counter] Applying icon to: $($repo.FullName)"

    $desktopIni = Join-Path $repo.FullName "desktop.ini"
    @"
[.ShellClassInfo]
IconResource=$gitIcon,0
"@ | Set-Content -Path $desktopIni -Encoding Unicode

    attrib +s +r $repo.FullName
    attrib +h $desktopIni
}

Write-Host "`nDone! Git icons applied."
