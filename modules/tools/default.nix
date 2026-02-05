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
    claudeCode

    # PHASE 2: mise now manages ~70 tools (languages, CLI utils, infra tools)
    # Keeping only tools that are complex to build, Nix-specific, or not in mise
    mise

    # Nix-specific tools
    nixos-generators
    cf-terraforming
    kas
    neovim-remote
    tree-sitter
    nerd-fonts.iosevka
    nix-prefetch-git
    nixd
    nixfmt
    cachix

    # Media processing tools
    p7zip
    xorriso
    smartcat
    socat
    ffmpeg_7
    hping
    iperf
    potrace
    imagemagick
    pngquant
    jpegoptim
    tesseract

    # Terminal & system utilities
    zellij
    zsh-syntax-highlighting
    cloc
    postgresql
    htop
    silver-searcher
    unixtools.watch
    fortune
    jump
    tig
    tree
    peco
    httpie
    wget
    nmap
    inetutils

    # Security tools
    sops
    age
    git-crypt

    # Complex formatters & LSP servers (hard to build via mise)
    hclfmt
    erlang-language-platform
    rust-analyzer
    rustfmt
    erlfmt

    # Cloud tools not in mise or with complex dependencies
    google-cloud-sdk
    linode-cli
    flyctl
    azure-cli
    awscli2
    infracost

    # Container & infrastructure tools with complex builds
    skopeo
    dive
    packer
    nomad
    vault
    ansible

    # Language-specific tools
    python313Packages.diagrams
    python313Packages.graphviz
    (gleam.overrideAttrs (old: {
      doCheck = false; # Skip tests on x86_64-darwin (CI)
    }))
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
