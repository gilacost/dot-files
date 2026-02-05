{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs)
    writeShellScriptBin
    ;
  claudeCode = pkgs.writeShellScriptBin "claude" ''
    # Set up npm global prefix to avoid permission issues  
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

    # Create npm global directory if it doesn't exist
    mkdir -p "$NPM_CONFIG_PREFIX"

    # Check if claude is installed and working
    if ! "$NPM_CONFIG_PREFIX/bin/claude" --version &> /dev/null; then
      echo "Installing @anthropic-ai/claude-code..."
      ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code
      
      # Verify installation
      if ! "$NPM_CONFIG_PREFIX/bin/claude" --version &> /dev/null; then
        echo "Installation failed or claude binary not found at expected location."
        echo "Trying to find claude binary..."
        
        # Try to find where npm actually installed it
        CLAUDE_PATH=$(find "$NPM_CONFIG_PREFIX" -name "claude" -type f -executable 2>/dev/null | head -1)
        
        if [ -n "$CLAUDE_PATH" ]; then
          echo "Found claude at: $CLAUDE_PATH"
          exec "$CLAUDE_PATH" "$@"
        else
          echo "Could not find claude binary. Trying npx as fallback..."
          exec ${pkgs.nodejs}/bin/npx @anthropic-ai/claude-code "$@"
        fi
      fi
    fi

    # Run claude command
    exec "$NPM_CONFIG_PREFIX/bin/claude" "$@"
  '';
in
{
  home.packages = with pkgs; [
    # ========================================================================
    # Custom Tools
    # ========================================================================
    claudeCode  # Custom wrapper for Claude CLI

    # ========================================================================
    # Tool Version Manager
    # ========================================================================
    mise  # Manages language runtimes and CLI tools (see ~/.config/mise/config.toml)

    # ========================================================================
    # Nix-Specific Tools (MUST stay in Nix)
    # ========================================================================
    nixd                   # Nix LSP server
    nixfmt-rfc-style       # Nix formatter
    nix-prefetch-git       # Nix utility for fetching git sources
    cachix                 # Nix binary cache
    nixos-generators       # NixOS image generators

    # ========================================================================
    # System Integration & Security (better via Nix)
    # ========================================================================
    zsh-syntax-highlighting  # Shell integration
    git-crypt                # Git encryption
    age                      # Modern encryption tool
    sops                     # Secrets management

    # ========================================================================
    # Complex Packages with System Dependencies
    # ========================================================================
    google-cloud-sdk       # GCP CLI (complex Python + system deps)
    azure-cli              # Azure CLI (complex Python + system deps)
    awscli2                # AWS CLI (Python + system deps)
    postgresql             # Database with system libs
    imagemagick            # Graphics libs
    ffmpeg_7               # Media processing
    tesseract              # OCR with training data

    # ========================================================================
    # Fonts
    # ========================================================================
    nerd-fonts.iosevka

    # ========================================================================
    # Specialized/Niche Tools (keeping in Nix for stability)
    # ========================================================================
    neovim-remote          # nvim remote control
    tree-sitter            # Required for nvim treesitter
    cf-terraforming        # Cloudflare → Terraform
    kas                    # Kubernetes deployment tool
    smartcat               # Smart file concatenation
    p7zip                  # Archive utility
    xorriso                # ISO manipulation
    potrace                # Bitmap tracing
    linode-cli             # Linode CLI
    flyctl                 # Fly.io CLI
    infracost              # Cloud cost estimation
    dive                   # Docker image analyzer
    skopeo                 # Container image operations
    (gleam.overrideAttrs (old: {
      doCheck = false;     # Skip tests on x86_64-darwin
    }))
    python313Packages.diagrams
    python313Packages.graphviz

    # ========================================================================
    # Simple Unix Tools (keeping in Nix for now)
    # ========================================================================
    socat
    hping
    iperf
    fortune
    wget
    nmap
    inetutils
    unixtools.watch
    tree
    peco
    httpie
    tig
    silver-searcher        # ag
    htop
    cloc
    jump
    pngquant
    jpegoptim
    zellij
    ansible

    # ========================================================================
    # Migrated to mise (see conf.d/mise/config.toml)
    # ========================================================================
    # - Language runtimes: node, erlang, elixir, python, go, rust
    # - CLI tools: ripgrep, fd, bat, zoxide, jq, yq, lazygit, glow, hugo
    # - LSPs: typescript-language-server, bash-language-server, yaml-language-server, etc.
    # - Formatters: prettier, shellcheck, hadolint, etc.
    # - Infrastructure: terraform, terragrunt, kubectl, helm, vault, packer, nomad
    # - Kubernetes: argocd, kind, skaffold, kompose
    # - Development: lua-language-server, d2, sentry-cli, rust-analyzer
    # ========================================================================
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bat = {
    enable = true;
    themes = {
      "tokyonight-moon" = {
        src = ./bat/tokyonight-moon.tmTheme;
        file = null;
      };
      "tokyonight-day" = {
        src = ./bat/tokyonight-day.tmTheme;
        file = null;
      };
    };
    config = {
      theme = "tokyonight-day";
    };
  };
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };
}
