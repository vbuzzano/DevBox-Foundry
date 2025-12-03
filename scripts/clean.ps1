# ==============================================================================
# ApolloDevBox - Clean Script
# ==============================================================================

$ErrorActionPreference = "Stop"

$DIST_DIR = "dist"

Write-Host "Cleaning..." -ForegroundColor Cyan

try {
    if (Test-Path $DIST_DIR) {
        Remove-Item -Recurse -Force $DIST_DIR
        Write-Host "✅ OK Clean complete" -ForegroundColor Green
    }
    else {
        Write-Host "✅ OK Already clean" -ForegroundColor Green
    }
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
