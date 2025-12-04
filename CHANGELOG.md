# DevBox Foundry - Changelog

All notable changes to DevBox Foundry are documented in this file.

## [0.1.0] - 2025-12-04

### Added

#### Core Features
- ✅ **Standalone `install.ps1` installer** - Zero external dependencies beyond git
- ✅ **Project structure generation** - Auto-creates `.box/`, `.vscode/`, `.env`, `box.config.psd1`, `README.md`
- ✅ **Template-based configuration** - `box.config.template` with `{{PLACEHOLDER}}` substitution
- ✅ **Environment variable management** - `.env` file + `.env.ps1` loader script
- ✅ **VS Code integration** - Pre-configured settings, tasks, launch configurations
- ✅ **Dual-repo architecture** - DevBox-Foundry (dev) + AmigaDevBox (release distribution)

#### Build System
- ✅ **GNU Make targets** - `help`, `build`, `clean`, `release`, `commit`, `push`
- ✅ **PowerShell build scripts** - Modular, reusable orchestration
- ✅ **Release pipeline** - Automated nested `.git` protection and distribution

#### Configuration & Templates
- ✅ **README template** - `{{PROJECT_NAME}}` and `{{PROJECT_DESCRIPTION}}` placeholders
- ✅ **Project config template** - Name, Description, ProgramName, Version, DefaultCPU, DefaultFPU
- ✅ **VS Code templates** - `.vscode/settings.json`, `tasks.json`, `launch.json`
- ✅ **Makefile templates** - Generic and Amiga-specific build configurations

#### Project Setup
- ✅ **Interactive project creation** - User-friendly wizard flow
- ✅ **Name sanitization** - Removes invalid characters from project names
- ✅ **Environment setup** - Creates `.env` with PROJECT_NAME, PROJECT_DESCRIPTION, PROGRAM_NAME, VERSION
- ✅ **Line ending enforcement** - UTF-8 LF globally via `.gitattributes`

### Fixed
- ✅ **`.gitignore` root-only pattern** - Allows `devbox/tpl/.vscode/` in git while ignoring root `.vscode/`
- ✅ **Redundant `.env.ps1` copy** - Removed duplicate copy in `install.ps1`
- ✅ **Template file existence checks** - Simplified code by trusting `git clone` guarantees
- ✅ **README configuration text** - Changed from "AmigaBoxDev Configuration" to "Project Configuration"
- ✅ **Config file path reference** - Updated to `box.config.psd1` (root) instead of `.box/config.psd1`

### Changed
- ✅ **Renamed `setup.config.template`** → `box.config.template` (for clarity, pending implementation)
- ✅ **README subtitle** - Now uses `{{PROJECT_DESCRIPTION}}` placeholder instead of fixed text
- ✅ **Installation flow** - Simplified without file existence guards

### Removed
- ✅ **Unnecessary defensive programming** - Removed redundant `if (Test-Path ...)` checks
- ✅ **Redundant `.env.ps1` bootstrap copy** - `.env.ps1` already available from `git clone`
- ✅ **PROJECT_DESCRIPTION from `.env`** - Kept only for config/README, not env export

### Known Issues
- ⚠️ **Git clone subdirectory** - Current approach creates `.box/` as nested git repo (will be replaced with archive distribution)
- ⚠️ **Version management** - No version selection during install (all installs get latest)
- ⚠️ **Update mechanism** - No built-in update/upgrade path yet

### Future (Planned)
- 📅 **Archive-based distribution** - Replace `git clone` with versioned `.zip` downloads from GitHub Releases
- 📅 **Version selection** - Allow users to choose AmigaDevBox version during install
- 📅 **Update command** - `box.ps1 upgrade` to optionally update to newer versions
- 📅 **Rollback support** - Keep multiple versions for safe rollback if updates break projects
- 📅 **Package management** - Re-implement package install/uninstall with proper tracking

---

## Notes for Users

### Getting Started
```powershell
# Download and run installer
irm https://github.com/vbuzzano/AmigaDevBox/raw/main/install.ps1 | iex

# Follow interactive wizard
# Creates project with .box/, .vscode/, .env, config, etc.

cd MyProject
.\box.ps1 init
```

### Known Limitations
- Git clone method creates nested `.box/.git` (clean solution pending)
- All installs default to latest AmigaDevBox version
- No built-in version management yet
