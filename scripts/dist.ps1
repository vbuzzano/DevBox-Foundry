# ==============================================================================
# ApolloDevBox - Distribution Build Script
# ==============================================================================

$ErrorActionPreference = "Stop"

$VERSION = "0.1.0"
$DIST_DIR = "dist"
$RELEASE_DIR = "$DIST_DIR\release"
$DEVBOX_DIR = "devbox"
$TPL_DIR = "$DEVBOX_DIR\tpl"

Write-Host "Building ApolloDevBox v$VERSION..." -ForegroundColor Cyan

try {
    # Create directories
    $dirs = @(
        "$RELEASE_DIR\.box\inc",
        "$RELEASE_DIR\.box\tpl",
        "$RELEASE_DIR\.box\tools",
        "$RELEASE_DIR\.vscode"
    )
    $dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }

    # Copy system
    Write-Host "Copying system..." -ForegroundColor Yellow
    Copy-Item -Recurse -Force "$DEVBOX_DIR\inc\*" "$RELEASE_DIR\.box\inc\"
    Copy-Item -Recurse -Force "$DEVBOX_DIR\tpl\*" "$RELEASE_DIR\.box\tpl\"
    Copy-Item -Recurse -Force "$DEVBOX_DIR\tools\*" "$RELEASE_DIR\.box\tools\"
    Copy-Item -Force "$DEVBOX_DIR\config.psd1" "$RELEASE_DIR\.box\"

    # Copy templates
    Write-Host "Copying templates..." -ForegroundColor Yellow
    Copy-Item -Recurse -Force "$TPL_DIR\.vscode\*" "$RELEASE_DIR\.vscode\"
    Copy-Item -Force "$DEVBOX_DIR\setup.ps1" "$RELEASE_DIR\box.ps1"

    # Copy root files
    Write-Host "Copying root files..." -ForegroundColor Yellow
    Copy-Item -Force ".gitignore" "$RELEASE_DIR\"
    Copy-Item -Force "LICENSE" "$RELEASE_DIR\"
    Copy-Item -Force "README.md" "$RELEASE_DIR\"

    Write-Host "✅ OK v$VERSION ready in $RELEASE_DIR" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
