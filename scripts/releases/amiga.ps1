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

# Copy core DevBox system
Write-Host "Copying DevBox system..." -ForegroundColor Yellow
Copy-Item -Recurse -Force "$DevBoxDir\inc\*" "$ReleaseDir\.box\inc\"
Copy-Item -Recurse -Force "$DevBoxDir\tpl\*" "$ReleaseDir\.box\tpl\"
Copy-Item -Recurse -Force "$DevBoxDir\tools\*" "$ReleaseDir\.box\tools\"
Copy-Item -Force "$DevBoxDir\config.psd1" "$ReleaseDir\.box\"

# Copy templates
Write-Host "Copying templates..." -ForegroundColor Yellow
Copy-Item -Recurse -Force "$DevBoxDir\tpl\.vscode\*" "$ReleaseDir\.vscode\"
Copy-Item -Force "$DevBoxDir\setup.ps1" "$ReleaseDir\box.ps1"

    # Copy root files with tag substitution
    Write-Host "Copying root files..." -ForegroundColor Yellow
    $rootFiles = @(".gitignore", "LICENSE")
    foreach ($file in $rootFiles) {
        if (Test-Path $file) {
            Copy-Item -Force $file "$ReleaseDir\"
        }
    }

    # Copy README.release.md as README.md for the release
    if (Test-Path "$DevBoxDir\tpl\README.release.md") {
        Copy-Item -Force "$DevBoxDir\tpl\README.release.md" "$ReleaseDir\README.md"
    }

    # Copy install.ps1 to root of release (for end users to download and run)
    if (Test-Path "$DevBoxDir\install.ps1") {
        Copy-Item -Force "$DevBoxDir\install.ps1" "$ReleaseDir\install.ps1"
    }Write-Host "✅ Amiga release configured" -ForegroundColor Green
