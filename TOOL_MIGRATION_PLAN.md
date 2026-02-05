# Tool Migration Plan: Nix → Mise

## Summary
- **Total tools**: ~120
- **Moving to mise**: ~70
- **Staying in Nix**: ~35
- **Already in Homebrew**: ~15

---

## Tools Moving to Mise

### Language Runtimes (mise core)
- ✅ node
- ✅ erlang
- ✅ elixir
- ✅ python
- ✅ go
- ✅ rust (replaces: cargo, rustc, cargo-edit)

### CLI Tools (cargo)
- ✅ ripgrep
- ✅ fd-find
- ✅ bat
- ✅ zoxide
- ✅ sd
- ✅ just
- ✅ tokei
- ✅ git-delta
- ✅ eza (modern ls)
- ⚠️  cargo-edit (comes with rust in mise)

### Development Tools (npm)
- ✅ prettier
- ✅ typescript-language-server (replaces: nodePackages_latest.typescript-language-server)
- ✅ bash-language-server (replaces: nodePackages.bash-language-server)
- ✅ yaml-language-server (replaces: nodePackages.yaml-language-server)
- ✅ dockerfile-language-server-nodejs-npm (replaces: nodePackages.dockerfile-language-server-nodejs)
- ✅ vim-language-server (replaces: nodePackages.vim-language-server)
- ✅ markdownlint-cli (replaces: nodePackages.markdownlint-cli)
- ✅ cspell (replaces: nodePackages.cspell)
- ✅ vscode-langservers-extracted
- ✅ node2nix (replaces: nodePackages.node2nix)
- ✅ yarn
- ⚠️  npm (comes with node in mise)

### Infrastructure Tools (mise core or ubi)
- ✅ terraform
- ✅ terragrunt (2 instances in your config!)
- ✅ kubectl
- ✅ helm (replaces: kubernetes-helm)
- ✅ vault (ubi:hashicorp/vault)
- ✅ packer (ubi:hashicorp/packer)
- ✅ nomad (ubi:hashicorp/nomad)
- ✅ argocd (ubi:argoproj/argo-cd)
- ✅ tflint
- ✅ hclfmt
- ✅ terraform-docs
- ✅ terraformer

### Kubernetes Ecosystem (ubi)
- ✅ kind
- ✅ skaffold (ubi:GoogleContainerTools/skaffold)
- ✅ kompose

### CLI Utilities (various)
- ✅ jq (mise core)
- ✅ lazygit (ubi:jesseduffield/lazygit)
- ✅ glow (ubi:charmbracelet/glow)
- ✅ hugo (ubi:gohugoio/hugo)
- ✅ shellcheck (mise core)
- ✅ hadolint (ubi:hadolint/hadolint)
- ✅ yq (ubi:mikefarah/yq)
- ✅ dasel (ubi:TomWright/dasel)

### Rust Tools (cargo)
- ✅ rust-analyzer
- ✅ rustfmt (comes with rust)

### Elixir/Erlang Tools
- ✅ rebar3 (via mise elixir/erlang)
- ✅ erlang-language-platform (cargo:erlang-language-platform or elp)
- ⚠️  erlfmt (need to check availability)

### Other Development Tools
- ✅ lua-language-server (ubi:LuaLS/lua-language-server)
- ✅ tailwindcss-language-server (npm:@tailwindcss/language-server)
- ✅ d2 (ubi:terrastruct/d2)
- ✅ sentry-cli (ubi:getsentry/sentry-cli)

---

## Tools Staying in Nix

### Nix-Specific (MUST stay)
- nixd
- nixfmt-rfc-style
- nix-prefetch-git
- cachix
- nixos-generators

### Complex System Dependencies
- google-cloud-sdk (complex Python + system deps)
- azure-cli (complex Python + system deps)
- awscli2 (Python + system deps)
- postgresql (database with system libs)
- imagemagick (complex graphics libs)
- ffmpeg_7 (complex media libs)
- tesseract (OCR with training data)

### System Integration Tools
- zsh-syntax-highlighting (shell integration)
- direnv (needed for nix-direnv)
- git-crypt (system encryption)
- age (encryption)
- sops (secrets management)

### Fonts
- nerd-fonts.iosevka

### Specialized/Niche Tools
- claudeCode (custom wrapper script)
- neovim-remote
- tree-sitter (needed for nvim config)
- cf-terraforming
- kas
- smartcat
- p7zip
- xorriso
- potrace
- linode-cli
- flyctl
- infracost
- dive (could move to ubi, but works in nix)
- skopeo
- gleam (with custom overrides)
- python313Packages.diagrams
- python313Packages.graphviz

### Simple Unix Tools (keep for stability)
- socat
- hping
- iperf
- fortune
- wget
- nmap
- inetutils
- unixtools.watch
- tree
- peco
- httpie
- tig
- silver-searcher (ag)
- htop
- cloc
- jump
- pngquant
- jpegoptim
- zellij
- ansible

---

## Already in Homebrew (darwin-configuration.nix)
- mas
- dive (duplicate! also in Nix)
- coreutils
- ansible (duplicate! also in Nix)
- amazon-ecs-cli
- fwup
- qemu

---

## Action Items

1. Create `conf.d/mise/config.toml` with ~70 tools
2. Update `modules/tools/default.nix` to remove ~70 tools
3. Add mise activation to zsh config
4. Test: `mise install` and verify all tools work
5. Rebuild nix-darwin
6. Clean up duplicates (terragrunt, dive, ansible)

---

## Notes

- Some tools may need `ubi:owner/repo` format if not in mise core
- Check mise registry: `mise registry`
- For unavailable tools, keep in Nix or add via `mise use -g cargo:tool`
- Consider moving simple CLI tools (tree, wget, etc.) to mise later for consistency
