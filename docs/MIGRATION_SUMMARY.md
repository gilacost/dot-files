# Tool Migration Summary: Nix → Mise

## Changes Made

### Files Modified
1. **darwin-configuration.nix** - Removed duplicate brews (dive, ansible)
2. **home.nix** - Added mise config symlink
3. **modules/tools/default.nix** - Removed ~70 tools, keeping only Nix-specific/complex ones
4. **modules/zsh/default.nix** - Added mise activation
5. **conf.d/mise/config.toml** - Created with ~70 tools

### Files Created
- `conf.d/mise/config.toml` - Global mise configuration
- `TOOL_MIGRATION_PLAN.md` - Detailed migration plan
- `MIGRATION_SUMMARY.md` - This file

---

## Testing Steps

### 1. Rebuild nix-darwin
```bash
cd ~/Repos/dot-files
darwin-rebuild switch --flake .
```

This will:
- Install mise via home-manager
- Update zsh to activate mise
- Remove old Nix-managed tools
- Symlink mise config to ~/.config/mise/config.toml

### 2. Start a New Shell
```bash
# Open a new terminal or:
exec zsh
```

### 3. Verify mise is Activated
```bash
mise --version
# Should show mise version

mise doctor
# Should show mise is properly configured
```

### 4. Install All Tools
```bash
mise install
```

This will install ~70 tools defined in config.toml. May take 5-15 minutes.

### 5. Verify Tools are Available
```bash
# Language runtimes
node --version
elixir --version
erlang --version
python --version
go version
rustc --version

# CLI tools
rg --version        # ripgrep (cargo)
fd --version        # fd-find (cargo)
bat --version       # bat (cargo)
jq --version        # jq (mise core)

# Infrastructure
terraform --version
kubectl version --client
helm version

# LSPs (npm)
typescript-language-server --version
bash-language-server --version

# Check mise list
mise list
```

### 6. Verify Nix Tools Still Work
```bash
# Nix-specific
nixd --version
nixfmt --version

# Complex packages
gcloud --version
az --version
aws --version
psql --version

# Fonts should still be installed
# Check: System Settings → Fonts → look for Iosevka Nerd Font
```

### 7. Test nvim Launch via skhd
```bash
# Press: Cmd+Return
# Should open kitty with nvim and have access to all tools
```

---

## Expected Results

### Tools Now in mise (~70)
- Language runtimes: node, erlang, elixir, python, go, rust
- CLI utilities: ripgrep, fd, bat, zoxide, jq, yq, lazygit, glow, hugo
- LSPs: typescript-language-server, bash-language-server, yaml-language-server, etc.
- Formatters: prettier, shellcheck, hadolint
- Infrastructure: terraform, terragrunt, kubectl, helm, vault, packer, nomad
- Kubernetes: argocd, kind, skaffold, kompose
- Development: lua-language-server, d2, sentry-cli, rust-analyzer

### Tools Still in Nix (~40)
- Nix-specific: nixd, nixfmt-rfc-style, nix-prefetch-git, cachix, nixos-generators
- Complex packages: google-cloud-sdk, azure-cli, awscli2, postgresql, imagemagick, ffmpeg_7, tesseract
- System integration: zsh-syntax-highlighting, git-crypt, age, sops
- Fonts: nerd-fonts.iosevka
- Specialized: neovim-remote, tree-sitter, dive, gleam, etc.
- Simple Unix tools: tree, wget, htop, ansible, etc.

---

## Rollback Plan

If something goes wrong:

```bash
cd ~/Repos/dot-files
git checkout master
darwin-rebuild switch --flake .
```

---

## Benefits

1. **Faster Updates**: `mise upgrade` vs full nix rebuild
2. **Project Versions**: `.mise.toml` per project for specific versions
3. **Simpler Syntax**: `mise use -g cargo:tool` vs editing Nix
4. **Multi-source**: Can install from cargo, npm, ubi (GitHub releases)
5. **Better for Teams**: Teammates don't need to know Nix

---

## Next Steps

After testing:
1. Commit changes
2. Create PR description
3. Consider moving more simple Unix tools to mise
4. Document project-specific mise usage
