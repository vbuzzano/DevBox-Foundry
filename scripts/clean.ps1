# ==============================================================================
# DevBox - Clean Script
# Cleans dist/ while preserving dist/release/.git repository
# ==============================================================================

$ErrorActionPreference = "Stop"

$DIST_DIR = "dist"
$RELEASE_DIR = "$DIST_DIR\release"
$GIT_DIR = "$RELEASE_DIR\.git"

Write-Host "Cleaning..." -ForegroundColor Cyan

try {
    if (Test-Path $DIST_DIR) {
        # Preserve .git if it exists in dist/release/
        $gitBackup = $null
        if (Test-Path $GIT_DIR) {
            Write-Host "Preserving .git repository..." -ForegroundColor Yellow
            $gitBackup = Join-Path $env:TEMP "devbox_git_$(Get-Random)"
            Move-Item -Path $GIT_DIR -Destination $gitBackup -Force
        }

        # Clean dist/ completely
        Remove-Item -Recurse -Force $DIST_DIR
        Write-Host "Cleaned $DIST_DIR" -ForegroundColor Green

        # Restore .git if it was backed up
        if ($gitBackup -and (Test-Path $gitBackup)) {
            New-Item -ItemType Directory -Force -Path $RELEASE_DIR | Out-Null
            Move-Item -Path $gitBackup -Destination $GIT_DIR -Force
            Write-Host ".git repository restored to $RELEASE_DIR" -ForegroundColor Green
        }

        Write-Host "✅ OK Clean complete" -ForegroundColor Green
    }
    else {
        Write-Host "✅ OK Already clean" -ForegroundColor Green
    }
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    # Cleanup backup if failed
    if ($gitBackup -and (Test-Path $gitBackup)) {
        Remove-Item -Recurse -Force $gitBackup -ErrorAction SilentlyContinue
    }
    exit 1
}
