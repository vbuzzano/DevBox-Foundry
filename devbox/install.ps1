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

# Check if git is installed
Write-Host "Checking git installation..." -ForegroundColor Cyan
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ git is not installed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Download git from: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "Then run this script again after installation." -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ git found" -ForegroundColor Green
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
$safeName = $ProjectName -replace '[/\\()^''":\[\]]', '-'
$targetDir = Join-Path (Get-Location) $safeName

if (Test-Path $targetDir) {
    Write-Host "❌ Directory '$safeName' already exists" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Creating project '$ProjectName'..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
Set-Location $targetDir

# Clone AmigaDevBox as .box
Write-Host "  ⏳ Cloning AmigaDevBox repository..." -ForegroundColor Cyan
git clone https://github.com/vbuzzano/AmigaDevBox.git .box 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to clone AmigaDevBox" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ AmigaDevBox cloned to .box" -ForegroundColor Green

# Generate box.config.psd1 from template
Write-Host "  ⏳ Generating box.config.psd1..." -ForegroundColor Cyan
$templatePath = ".\.box\tpl\setup.config.template"
if (Test-Path $templatePath) {
    $configContent = Get-Content $templatePath -Raw
    # Replace template values
    $configContent = $configContent -replace 'Name\s*=\s*"[^"]*"', "Name = `"$ProjectName`""
    $configContent = $configContent -replace 'Description\s*=\s*"[^"]*"', "Description = `"$Description`""
    Set-Content -Path "box.config.psd1" -Value $configContent -Encoding UTF8
    Write-Host "  ✓ Generated box.config.psd1" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Template not found, creating minimal config" -ForegroundColor Yellow
    $configContent = @"
@{
    Project = @{
        Name        = "$ProjectName"
        Description = "$Description"
        Version     = "0.1.0"
    }
    Envs = @{}
    Packages = @()
}
"@
    Set-Content -Path "box.config.psd1" -Value $configContent -Encoding UTF8
}

# Copy .box/box.ps1 to root (so user can run .\box.ps1 directly)
Write-Host "  ⏳ Setting up box.ps1..." -ForegroundColor Cyan
if (Test-Path ".\.box\box.ps1") {
    Copy-Item ".\.box\box.ps1" "box.ps1" -Force
    Write-Host "  ✓ Copied box.ps1 to root" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  .box/box.ps1 not found" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Project '$ProjectName' created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review and customize: box.config.psd1" -ForegroundColor White
Write-Host "  2. Initialize the project: .\box.ps1 init" -ForegroundColor White
Write-Host ""
Write-Host "📁 You are now in: $(Get-Location)" -ForegroundColor Cyan
