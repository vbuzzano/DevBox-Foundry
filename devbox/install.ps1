<#
.SYNOPSIS
    AmigaDevBox - Project Bootstrap Installer

.DESCRIPTION
    Downloads and sets up a new AmigaOS development project using AmigaDevBox.
    This script is meant to be run remotely via:
    irm https://github.com/vbuzzano/AmigaDevBox/raw/main/install.ps1 | iex

.NOTES
    Author: Vincent Buzzano (ReddoC)
    Date: December 2025
    Version: 0.1.0
#>

param(
    [string]$ProjectName,
    [string]$Description
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkMagenta
Write-Host "            🧙 DevBox Foundry v0.1.0 🧙" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkMagenta
Write-Host ""

# Get project name
if (-not $ProjectName) {
    $ProjectName = Read-Host "Project Name"
    if (-not $ProjectName) {
        Write-Host "❌ Project name is required" -ForegroundColor Red
        exit 1
    }
}

# Get description
if (-not $Description) {
    $Description = Read-Host "Description (optional)"
}

# Sanitize project name
$safeName = $ProjectName -replace '[<>:"/\\|?*]', '_'
$targetDir = Join-Path (Get-Location) $safeName

if (Test-Path $targetDir) {
    Write-Host "❌ Directory '$safeName' already exists" -ForegroundColor Red
    exit 1
}

# Create project directory
Write-Host "Creating project '$ProjectName'..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

# TODO: Download/clone AmigaDevBox system into project
# For now: placeholder
Write-Host "✅ Project '$ProjectName' created" -ForegroundColor Green

# Change to project directory
Set-Location $targetDir
Write-Host "📁 Changed to $(Get-Location)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: .\box.ps1 install" -ForegroundColor Yellow
