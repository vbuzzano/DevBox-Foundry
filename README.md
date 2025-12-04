# DevBox Foundry

Development Kit for AmigaOS Cross-Compilation on Windows with VBCC.

## 🚀 Quick Start

### For Users (Creating Projects)

```powershell
# Download and run the standalone installer
irm https://github.com/vbuzzano/AmigaDevBox/raw/main/install.ps1 | iex

# Follow the interactive wizard:
# - Enter project name
# - Enter project description
# - Done! Project created with all boilerplate

cd MyProject
.\box.ps1 install   # Install packages
make                # Build
```

### For Developers (Working on DevBox)

```powershell
git clone https://github.com/vbuzzano/DevBox-Foundry.git
cd DevBox-Foundry

make help       # Show all targets
make build      # Build release
make commit     # Git commit with message
make push       # Git push
make release    # Build + commit + push (full workflow)
```

## 📦 What Gets Created

When you run `install.ps1`, you get a complete project structure:

```
MyProject/
  .box/                    # AmigaDevBox repository snapshot
    app.ps1               # Main DevBox script
    inc/                  # PowerShell helpers
    tpl/                  # Templates & examples
    config.psd1           # Default configuration
    
  .vscode/                 # VS Code pre-configured
    settings.json
    tasks.json
    launch.json
    
  box.ps1                  # Wrapper script (delegates to .box/app.ps1)
  box.config.psd1          # Your project configuration
  .env                     # Environment variables
  README.md                # Auto-generated from template
```

## 🛠️ Make Targets

- `make help` - Show all targets
- `make build` - Build distribution
- `make clean` - Clean build artifacts
- `make commit MSG="message"` - Git commit with message
- `make push` - Git push
- `make release` - Full workflow: build → commit → push

## 📝 Project Configuration

Edit `box.config.psd1` to customize packages and build settings.

## 🔄 Two-Repository Architecture

**DevBox-Foundry** (Development)
- Main repository for development
- Contains full `devbox/`, `scripts/`, tests
- Published to: `https://github.com/vbuzzano/DevBox-Foundry`

**AmigaDevBox** (Distribution)
- Release distribution in `dist/release/`
- Separate git repository
- Published to: `https://github.com/vbuzzano/AmigaDevBox`
- What users download via `install.ps1`

## 📄 License

See LICENSE file.

**Powered by Vincent Buzzano (ReddoC)**