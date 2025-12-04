# ==============================================================================
# DevBox Foundry - Commit Script
# ==============================================================================

param(
    [string]$Message
)

$ErrorActionPreference = "Stop"

Write-Host "Git Commit..." -ForegroundColor Cyan

try {
    $status = git status --short
    if ($status) {
        Write-Host "Changes detected:" -ForegroundColor Yellow
        Write-Host $status
        
        $commitMessage = if ($Message) { $Message } else { Read-Host "Commit message" }
        
        if ($commitMessage) {
            git add -A
            git commit -m $commitMessage
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
