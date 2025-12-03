# Clean test sandbox
# Removes all test artifacts

param(
    [switch]$All
)

$ErrorActionPreference = "Stop"

Write-Host "🧹 Cleaning test environment..." -ForegroundColor Cyan

$sandboxPath = Join-Path $PSScriptRoot "sandbox"

if (Test-Path $sandboxPath) {
    Write-Host "Removing sandbox directory..." -ForegroundColor Yellow
    Get-ChildItem $sandboxPath -Recurse | Remove-Item -Force -Recurse
    Write-Host "✅ Sandbox cleaned" -ForegroundColor Green
} else {
    Write-Host "✅ Sandbox already clean" -ForegroundColor Green
}

if ($All) {
    Write-Host "Deep clean requested..." -ForegroundColor Yellow
    # Add more cleanup here if needed
}

Write-Host "✅ Clean complete!" -ForegroundColor Green
