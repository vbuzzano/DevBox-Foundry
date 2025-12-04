# ==============================================================================
# DevBox - Release Script
# Commits and pushes dist/release/ to release repository
# ==============================================================================

param(
    [string]$Release = "amiga",
    [string]$Message = "Release build"
)

$ErrorActionPreference = "Stop"

$RELEASE_DIR = "dist\release"
$RELEASE_SCRIPT = "scripts\releases\$Release.ps1"

Write-Host "Releasing $Release..." -ForegroundColor Cyan

try {
    # Verify dist/release exists
    if (-not (Test-Path $RELEASE_DIR)) {
        Write-Host "❌ Error: $RELEASE_DIR not found. Run 'make build' first." -ForegroundColor Red
        exit 1
    }

    # Get release metadata from .vscode/settings.json
    $settingsPath = ".vscode\settings.json"
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath | ConvertFrom-Json
        if ($settings.PSObject.Properties.Name -contains "devbox.releases") {
            $releases = $settings."devbox.releases"
            if ($releases.PSObject.Properties.Name -contains $Release) {
                $releaseConfig = $releases.$Release
                $releaseName = $releaseConfig.name
                $releaseRepo = $releaseConfig.repository
            }
            else {
                Write-Host "⚠️ Warning: Release '$Release' not found in settings" -ForegroundColor Yellow
                $releaseName = $Release
                $releaseRepo = "origin"
            }
        }
        else {
            Write-Host "⚠️ Warning: No releases configured in settings" -ForegroundColor Yellow
            $releaseName = $Release
            $releaseRepo = "origin"
        }
    }
    else {
        Write-Host "⚠️ Warning: .vscode/settings.json not found" -ForegroundColor Yellow
        $releaseName = $Release
        $releaseRepo = "origin"
    }

    # Verify .git exists in dist/release
    if (-not (Test-Path "$RELEASE_DIR\.git")) {
        Write-Host "Initializing git repository in $RELEASE_DIR..." -ForegroundColor Yellow
        Push-Location $RELEASE_DIR
        git init
        git branch -M main
        git remote add origin $releaseRepo
        Pop-Location
    }

    # Enter release directory and commit
    Push-Location $RELEASE_DIR

    # Check for changes
    $status = git status --porcelain
    if ($status) {
        Write-Host "Committing changes to $releaseName..." -ForegroundColor Yellow
        git add -A
        git commit -m "Release $releaseName - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        Write-Host "✅ Committed" -ForegroundColor Green
    }
    else {
        Write-Host "No changes to commit" -ForegroundColor Yellow
    }

    # Push to origin
    Write-Host "Pushing to $releaseName repository..." -ForegroundColor Yellow
    git push -u origin main 2>&1 | ForEach-Object { Write-Host $_ }
    Write-Host "✅ OK Release pushed successfully" -ForegroundColor Green

    Pop-Location
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Pop-Location -ErrorAction SilentlyContinue
    exit 1
}
