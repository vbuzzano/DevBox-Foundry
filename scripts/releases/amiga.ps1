# ==============================================================================
# DevBox - Amiga Release Configuration
# Specific build logic for AmigaDevBox release
# ==============================================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$ReleaseDir,
    
    [Parameter(Mandatory=$true)]
    [string]$DevBoxDir,
    
    [string]$Version = "0.1.0"
)

$ErrorActionPreference = "Stop"

Write-Host "Configuring Amiga release..." -ForegroundColor Cyan

# Release metadata
$ReleaseName = "AmigaDevBox"
$ReleaseDescription = "Complete Amiga OS development kit setup"
$ReleaseRepo = "https://github.com/vbuzzano/AmigaDevBox"

# Copy core DevBox system (without tools, .vscode)
Write-Host "Copying DevBox system..." -ForegroundColor Yellow
Copy-Item -Recurse -Force "$DevBoxDir\inc\*" "$ReleaseDir\inc\"
Copy-Item -Recurse -Force "$DevBoxDir\tpl\*" "$ReleaseDir\tpl\"
Copy-Item -Force "$DevBoxDir\config.psd1" "$ReleaseDir\config.psd1"

# Create box.ps1 wrapper script (temporary, will be replaced by install.ps1)
Write-Host "Creating box.ps1 wrapper..." -ForegroundColor Yellow
$wrapperContent = @'
<#
.SYNOPSIS
    DevBox-Foundry bootstrap wrapper

.DESCRIPTION
    Temporary wrapper that will be replaced by the real box.ps1 after install.ps1 runs.
    Until then, this delegates to app.ps1 or .box/app.ps1.
#>

param(
    [string]$Command
)

# Try to find app.ps1 (root first, then .box/)
$appScript = if (Test-Path "app.ps1") { "app.ps1" } elseif (Test-Path ".box\app.ps1") { ".box\app.ps1" } else { $null }

if (-not $appScript) {
    Write-Host "ERROR: DevBox app not found. Run: .\install.ps1" -ForegroundColor Red
    exit 1
}

& $appScript @args
'@
Set-Content -Path "$ReleaseDir\box.ps1" -Value $wrapperContent -Encoding UTF8

# Copy root files
Write-Host "Copying root files..." -ForegroundColor Yellow
$rootFiles = @(".gitignore", "LICENSE")
foreach ($file in $rootFiles) {
    if (Test-Path $file) {
        Copy-Item -Force $file "$ReleaseDir\"
    }
}

# Copy app.ps1 as app.ps1 (the real devbox script)
if (Test-Path "$DevBoxDir\app.ps1") {
    Copy-Item -Force "$DevBoxDir\app.ps1" "$ReleaseDir\app.ps1"
}

# Copy README.release.md as README.md for the release
if (Test-Path "$DevBoxDir\tpl\README.release.md") {
    Copy-Item -Force "$DevBoxDir\tpl\README.release.md" "$ReleaseDir\README.md"
}

# Copy install.ps1 to root of release
if (Test-Path "$DevBoxDir\install.ps1") {
    Copy-Item -Force "$DevBoxDir\install.ps1" "$ReleaseDir\install.ps1"
}

Write-Host "✅ Amiga release configured" -ForegroundColor Green
