# DevBox Foundry - Setup System Roadmap

## 🎯 Current Status: MVP Functional

**Version**: 0.1.0  
**Status**: ⚠️ Basic functionality, missing features

---

## ❌ Missing Features

### F0: Archive-based Distribution (PRIORITY)
- **Expected**: Replace `git clone` with versioned `.zip` downloads from GitHub Releases
- **Current**: Installs via `git clone` → creates nested `.box/.git` (messy, uncontrolled)
- **Problem**: 
  - Projects have `.box/` as Git submodule (confusing)
  - No version selection (always latest)
  - No rollback if version breaks project
  - Updates non-optional
- **Solution**:
  - Publish releases as `AmigaDevBox-v0.1.0.zip` on GitHub Releases
  - Installer downloads versioned zip instead of cloning
  - `box.ps1 upgrade` command for optional updates
  - Multiple versions can coexist (easy rollback)
- **Implementation**:
  1. Create GitHub Release with `.zip` artifact
  2. Modify `install.ps1` to download zip (default: latest, allow version param)
  3. Add `upgrade` function to `app.ps1`
  4. Document version management

### F1: Version Selection During Install
- **Expected**: Allow user to choose AmigaDevBox version
- **Current**: Always installs latest
- **Prompt**: `AmigaDevBox version [latest]: v0.1.0 v0.0.9 v0.0.8`

### F2: `pkg reinstall <name>` command
- **Expected**: Reinstall specific package by name
- **Current**: Must uninstall everything

### F3: `uninstall` cache option
- **Expected**: `.\box.ps1 uninstall` keeps cache, `.\box.ps1 uninstall -Purge` removes cache
- **Current**: Always removes `.setup/cache/`
- **Benefit**: Faster reinstall (no re-download)

### F4: "All" option for Y/n prompts
- **Expected**: Add `[A]ll` option to install all remaining packages without prompting
- **Current**: Must answer Y/n for each package individually
- **Prompt**: `Install? [Y]es [N]o [A]ll [a]:`

### F5: Individual file tracking
- **Expected**: Track every file copied, not just root directories
- **State format**:
```json
{
  "packages": {
    "NewMouse": {
      "installed": true,
      "files": [
        "include/libraries/newmouse.h"
      ],
      "createdDirs": [
        "include/libraries"
      ]
    }
  }
}
```

### F6: Config hash comparison
- **Expected**: Store hash of Extract rules in state
- **On install**: Compare current config vs stored hash
- **If different**: Force reinstall prompt for that package

### F7: Interactive install flow
```
=== DevBox-Foundry Setup ===

Project name [ApolloFreeWheel]: 
Description [FreeWheel for Vampire]: 

=== Packages ===

[1/8] VBCC Compiler (installed)
  [S]kip  [R]einstall  [M]anual  [s]: 

[2/8] NDK 3.2 (not installed)
  [I]nstall  [S]kip  [M]anual  [i]: 
```

### F8: Differentiate created vs existing directories
- Track if we created a directory or if it existed
- Only delete directories we created
- For existing dirs: only delete files we added

---

## 📋 Implementation Plan

### Phase 1: Core Features
1. [ ] F5: Individual file tracking in state.json
2. [ ] F3: Uninstall cache option (-Purge flag)
3. [ ] F4: Add "All" option to Y/n prompts
4. [ ] F8: Track created vs existing directories

### Phase 2: Package Commands
1. [ ] F2: Implement `pkg reinstall <name>`
2. [ ] F6: Add config hash to state
3. [ ] F7: Better interactive prompts

---

## 📝 Technical Notes

### Target State.json Structure
```json
{
  "version": "0.1.0",
  "configHash": "abc123",
  "project": {
    "name": "ApolloFreeWheel",
    "description": "FreeWheel for Vampire"
  },
  "packages": {
    "NewMouse": {
      "installed": true,
      "configHash": "def456",
      "files": [
        "include/libraries/newmouse.h"
      ],
      "createdDirs": [],
      "existingDirs": [
        "include/libraries"
      ]
    }
  }
}
```

### Extract Types Behavior
| Type | Typical Destination | Track Files? | Delete Dir? |
|------|---------------------|--------------|-------------|
| SDK | `sdk/NDK_3.2/` | Dir only | Yes (we create) |
| SRC | `vendor/freewheel/` | Dir only | Yes (we create) |
| INC | `include/libraries/file.h` | Each file | No (existing) |
| TOOL | `tools/vbcc/` | Dir only | Yes (we create) |
