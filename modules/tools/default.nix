{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
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
