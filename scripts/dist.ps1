# ==============================================================================
# DevBox - Distribution Build Script
# Orchestrates release build by calling specific release configuration scripts
# ==============================================================================

param(
    [string]$Release = "amiga"
)

$ErrorActionPreference = "Stop"

$VERSION = "0.1.0"
$DIST_DIR = "dist"
$RELEASE_DIR = "$DIST_DIR\release"
$DEVBOX_DIR = "devbox"
$GIT_DIR = "$RELEASE_DIR\.git"
$RELEASE_SCRIPT = "scripts\releases\$Release.ps1"

Write-Host "Building DevBox release: $Release v$VERSION..." -ForegroundColor Cyan

try {
    # Verify release script exists
    if (-not (Test-Path $RELEASE_SCRIPT)) {
        Write-Host "❌ Error: Release script not found: $RELEASE_SCRIPT" -ForegroundColor Red
        Write-Host "Available releases: $(Get-ChildItem scripts\releases\*.ps1 | ForEach-Object { $_.BaseName })" -ForegroundColor Yellow
        exit 1
    }

    # Preserve existing .git if present
    $gitBackup = $null
    if (Test-Path $GIT_DIR) {
        Write-Host "Preserving existing .git repository..." -ForegroundColor Yellow
        $gitBackup = Join-Path $env:TEMP "devbox_git_$(Get-Random)"
        Move-Item -Path $GIT_DIR -Destination $gitBackup -Force
    }

    # Clean and recreate release directory
    if (Test-Path $RELEASE_DIR) {
        Remove-Item -Recurse -Force $RELEASE_DIR
    }

    # Create base directories (selon la nouvelle structure)
    $dirs = @(
        "$RELEASE_DIR\inc",
        "$RELEASE_DIR\tpl"
    )
    $dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }

    # Restore .git
    if ($gitBackup -and (Test-Path $gitBackup)) {
        Move-Item -Path $gitBackup -Destination $GIT_DIR -Force
        Write-Host ".git repository restored" -ForegroundColor Green
    }

    # Call release-specific configuration script
    Write-Host "Executing $Release release configuration..." -ForegroundColor Yellow
    $releaseMetadata = & $RELEASE_SCRIPT -ReleaseDir $RELEASE_DIR -DevBoxDir $DEVBOX_DIR -Version $VERSION
    
    if ($releaseMetadata) {
        Write-Host "✅ OK $($releaseMetadata.Name) v$VERSION ready in $RELEASE_DIR" -ForegroundColor Green
    }
    else {
        Write-Host "✅ OK Release v$VERSION ready in $RELEASE_DIR" -ForegroundColor Green
    }
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    # Cleanup backup if failed
    if ($gitBackup -and (Test-Path $gitBackup)) {
        Remove-Item -Recurse -Force $gitBackup
    }
    exit 1
}
