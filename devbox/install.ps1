<#
.SYNOPSIS
    ApolloDevBox - Project Bootstrap Installer
    
.DESCRIPTION
    Downloads and sets up a new AmigaOS development project using ApolloDevBox.
    This script is meant to be run remotely via:
    iwr <url>/install.ps1 | iex
    
.NOTES
    Author: Vincent Buzzano (ReddoC)
    Date: December 3, 2025
    Version: 0.1.0
#>

param(
    [string]$ProjectName,
    [string]$Description,
    [ValidateSet("zip", "git")]
    [string]$Method = "git"
)

$ErrorActionPreference = "Stop"

# Colors
function Write-Title($text) { Write-Host $text -ForegroundColor Cyan }
function Write-Success($text) { Write-Host "✅ $text" -ForegroundColor Green }
function Write-Info($text) { Write-Host "ℹ️  $text" -ForegroundColor Yellow }
function Write-Error($text) { Write-Host "❌ $text" -ForegroundColor Red }

# Banner
Clear-Host
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║                                       ║" -ForegroundColor Magenta
Write-Host "  ║         🧙 ApolloDevBox 🧙           ║" -ForegroundColor Magenta
Write-Host "  ║                                       ║" -ForegroundColor Magenta
Write-Host "  ║   Amiga Development Kit Wizard        ║" -ForegroundColor Magenta
Write-Host "  ║                                       ║" -ForegroundColor Magenta
Write-Host "  ╚═══════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

Write-Title "Let's create your Amiga project! 🎮"
Write-Host ""

# Get project name
if (-not $ProjectName) {
    $ProjectName = Read-Host "Project Name"
    if (-not $ProjectName) {
        Write-Error "Project name is required"
        exit 1
    }
}

# Get description
if (-not $Description) {
    $Description = Read-Host "Description (optional)"
}

# Sanitize project name for filesystem
$safeName = $ProjectName -replace '[<>:"/\\|?*]', '_'
$targetDir = Join-Path (Get-Location) $safeName

if (Test-Path $targetDir) {
    Write-Error "Directory '$safeName' already exists"
    exit 1
}

Write-Host ""
Write-Info "Project: $ProjectName"
Write-Info "Directory: $targetDir"
Write-Info "Method: $Method"
Write-Host ""

# TODO: Implement download/clone logic
Write-Host "⚠️  Installation not yet implemented" -ForegroundColor Yellow
Write-Host ""
Write-Host "This will:" -ForegroundColor Gray
Write-Host "  1. Download/clone ApolloDevBox" -ForegroundColor Gray
Write-Host "  2. Create project structure" -ForegroundColor Gray
Write-Host "  3. Generate setup.config.psd1" -ForegroundColor Gray
Write-Host "  4. Initialize project" -ForegroundColor Gray
Write-Host ""

# Placeholder: Create minimal structure
Write-Info "Creating project directory..."
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

Write-Host ""
Write-Success "Project '$ProjectName' created in $targetDir"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. cd $safeName" -ForegroundColor White
Write-Host "  2. Edit setup.config.psd1 if needed" -ForegroundColor White
Write-Host "  3. .\setup.ps1 install" -ForegroundColor White
Write-Host ""
