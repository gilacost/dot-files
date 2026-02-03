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
    lazygit
    zoxide
    nixos-generators
    cf-terraforming
    kas
    # ssm-session-manager-plugin # Temporarily disabled due to Go vendoring issue
    neovim-remote
    tree-sitter
    p7zip
    xorriso
    smartcat
    socat
    ffmpeg_7
    hping
    iperf
    potrace
    zellij
    imagemagick
    pngquant
    jpegoptim
    zsh-syntax-highlighting
    cloc
    nodePackages.node2nix
    postgresql
    htop
    dasel
    silver-searcher
    nerd-fonts.iosevka
    unixtools.watch
    fortune
    hugo
    jump
    fd
    jq
    yq
    ripgrep
    glow
    tig
    tree
    peco
    httpie
    nix-prefetch-git
    wget
    nmap
    inetutils
    sops
    age
    git-crypt
    hclfmt
    erlang-language-platform
    tailwindcss-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    nodePackages_latest.typescript-language-server
    nixd
    rust-analyzer
    rustfmt
    hadolint
    nixfmt-rfc-style
    tflint
    nodePackages.prettier
    erlfmt
    shellcheck
    nodePackages.markdownlint-cli
    nodePackages.cspell
    vscode-langservers-extracted
    lua-language-server
    terragrunt
    packer
    skopeo
    skaffold
    nomad
    google-cloud-sdk
    linode-cli
    flyctl
    vault
    infracost
    dive
    kind
    terraform
    terragrunt
    kubectl
    kubernetes-helm
    terraformer
    terraform-docs
    azure-cli
    awscli2
    argocd
    ansible
    kompose
    cargo
    cargo-edit
    rustc
    go
    sentry-cli
    python313Packages.diagrams
    python313Packages.graphviz
    d2
    rebar3
    elixir
    erlang
    (gleam.overrideAttrs (old: {
      doCheck = false; # Skip tests on x86_64-darwin (CI)
    }))
    cachix
    nodePackages.npm
    yarn
    tesseract
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
