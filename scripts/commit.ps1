# ==============================================================================
# DevBox-Foundry - Commit Script
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "Git Commit..." -ForegroundColor Cyan

try {
    $status = git status --short
    if ($status) {
        Write-Host "Changes detected:" -ForegroundColor Yellow
        Write-Host $status
        
        $message = Read-Host "Commit message"
        if ($message) {
            git add -A
            git commit -m $message
            Write-Host "✅ OK Committed" -ForegroundColor Green
        }
        else {
            Write-Host "⚠️  Commit cancelled" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "✅ OK Nothing to commit" -ForegroundColor Green
    }
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
