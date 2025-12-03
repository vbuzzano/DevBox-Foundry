# ==============================================================================
# ApolloDevBox - Push Script
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "Git Push..." -ForegroundColor Cyan

try {
    $branch = git rev-parse --abbrev-ref HEAD
    Write-Host "Pushing to origin/$branch..." -ForegroundColor Yellow
    
    git push origin $branch
    Write-Host "✅ OK Pushed to origin/$branch" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
