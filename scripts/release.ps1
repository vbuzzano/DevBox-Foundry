# ==============================================================================
# ApolloDevBox - Release Script
# ==============================================================================

$ErrorActionPreference = "Stop"

$VERSION = "0.1.0"
$RELEASE_REPO = "..\ApolloDevBox-Release"

Write-Host "Releasing v$VERSION..." -ForegroundColor Cyan

try {
    # Check if release repo exists
    if (-not (Test-Path "$RELEASE_REPO\.git")) {
        Write-Host "❌ Error: Release repo not found at $RELEASE_REPO" -ForegroundColor Red
        Write-Host "Clone it first: git clone <repo-url> $RELEASE_REPO" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Syncing to release repo..." -ForegroundColor Yellow
    
    # Sync files
    $sourceDir = "dist\release"
    $targetDir = $RELEASE_REPO
    
    robocopy $sourceDir $targetDir /MIR /XD .git | Out-Null

    # Git operations in release repo
    Push-Location $RELEASE_REPO
    try {
        git add -A
        git commit -m "Release v$VERSION"
        git tag -a "v$VERSION" -m "Version $VERSION"
        git push origin main
        git push origin "v$VERSION"
    }
    finally {
        Pop-Location
    }

    Write-Host "✅ OK Released v$VERSION" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
