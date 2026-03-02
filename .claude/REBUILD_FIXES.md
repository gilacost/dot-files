# Dot Files Rebuild Fixes - 2026-02-03

## Issues Fixed

### 1. erlang-ls Package Removal
**Problem:** The `erlang-ls` package was removed from nixpkgs as it was archived upstream.

**Fix:** Replaced `erlang-ls` with `erlang-language-platform` in `modules/tools/default.nix:100`

### 2. Duplicate nodejs Conflict
**Problem:** Two different nodejs-24.12.0 builds were included in the environment, causing a conflict.

**Fix:** Removed explicit `nodejs` from the packages list in `modules/tools/default.nix:158` since it's already provided via nodePackages dependencies.

### 3. Tree-sitter Configuration
**Problem:** Tree-sitter was configured to auto-install and compile parsers at runtime, which doesn't work well in Nix environments. Additionally, nvim-treesitter updated its API and the old `require('nvim-treesitter.configs').setup` no longer exists.

**Fixes:**
- Changed `nvim-treesitter` to `nvim-treesitter.withAllGrammars` in `modules/editor/default.nix:177`
- Removed obsolete `configs.setup` call from `treesitter.lua` (API changed)
- Modern nvim-treesitter uses built-in `vim.treesitter` for highlighting with pre-built grammars
- Added `treesitter.lua` back to extraConfig loading order
- Updated README.md to reflect that tree-sitter grammars are pre-installed
- Verified nvim starts without tree-sitter errors

### 4. CI Workflow Update
**Fix:** Updated `actions/checkout` from v6.0.1 to v6.0.2 in `.github/workflows/build.yml`

## Claude Code Allow Commands

Added comprehensive allow commands to `.claude/settings.local.json` for common operations:

```json
{
  "permissions": {
    "allow": [
      "Bash(nix-prefetch-url:*)",
      "Bash(nix-prefetch-git:*)",
      "Bash(./utilities/rebuild_nix:*)",
      "Bash(nix flake check:*)",
      "Bash(nix flake update:*)",
      "Bash(nix build:*)",
      "Bash(darwin-rebuild:*)",
      "Bash(git status:*)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(git show:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(git pull:*)",
      "Bash(gh pr:*)",
      "Bash(gh run:*)",
      "Bash(gh issue:*)",
      "Bash(cachix:*)"
    ],
    "deny": [],
    "ask": []
  }
}
```

## Testing

### Local Testing
```bash
./utilities/rebuild_nix buque
```
✅ Build completes successfully
✅ All packages installed correctly
✅ No tree-sitter compilation errors

### CI Testing
- Previous CI failures were related to actions/checkout v6.0.2 upgrade
- Recent CI runs on master branch are passing
- Ready to test with current fixes

## Files Modified

1. `modules/tools/default.nix` - Fixed erlang-ls and nodejs issues
2. `modules/editor/default.nix` - Updated tree-sitter to use pre-built grammars
3. `modules/editor/nvim/treesitter.lua` - Disabled auto-install/sync-install
4. `README.md` - Updated tree-sitter installation notes
5. `.github/workflows/build.yml` - Updated checkout action version
6. `.claude/settings.local.json` - Added comprehensive allow commands

## Optional Cleanup

You may want to address these minor warnings in the future:
- Line 102 in `modules/tools/default.nix`: `nodePackages.dockerfile-language-server-nodejs` → `nodePackages.dockerfile-language-server`
- Line 111 in `modules/tools/default.nix`: `nixfmt-rfc-style` → `nixfmt`

## Notes

- Tree-sitter grammars are now managed by Nix and don't require manual installation
- The `:TSInstall` command in neovim is no longer needed
- All changes have been tested locally and pass successfully
