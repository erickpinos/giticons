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
    Write-Host "[$counter] Cleaning: $($repo.FullName)"

    $desktopIni = Join-Path $repo.FullName "desktop.ini"
    if (Test-Path $desktopIni) {
        $content = Get-Content $desktopIni -ErrorAction SilentlyContinue
        if ($content -match "git-for-windows\.ico") {
            Write-Host "→ Removing desktop.ini"
            Remove-Item $desktopIni -Force -ErrorAction SilentlyContinue
        }
    }

    Write-Host "→ Removing attributes"
    attrib -s -r $repo.FullName
}

Write-Host "`nDone! Git icons removed."
