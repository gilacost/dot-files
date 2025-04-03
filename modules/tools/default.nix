{ pkgs, ... }:
{
  #  TODO REVIEW ALL THESE PACKAGES
  # check https://github.com/jmackie/dotfiles/blob/main/modules/tools/default.nix
  home.packages = with pkgs; [
    nixos-generators
    kas
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
    # lxd
    # lxc

    # TO REVIEW
    # cmake
    # act
    # bind
    # coreutils
    zellij

    # STILL NEEDS TO BE ORGANISED
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
    # STILL NEEDS TO BE ORGANISED

    # RANDOM
    unixtools.watch
    fortune
    hugo
    jump

    # OUTPUT DATA MANIPULATION, SEARCH AND NAVIGATION
    fd
    jq
    yq
    ripgrep
    glow
    tig
    tree
    peco

    # HTTP, NETWORK AND CO
    httpie
    nix-prefetch-git
    wget
    nmap
    inetutils

    # SECRET MANAGEMENT
    sops
    git-crypt

    # LSP, LINTING AND FORMATTING
    hclfmt
    # elixir_ls
    # (callPackage (import ./elixir-ls.nix) {})
    erlang-ls
    lexical
    terraform-ls
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

    # CLOUD SDKS, OPS TOOLS AND WORKFLOW
    # pre-commit
    terragrunt
    packer
    skopeo
    skaffold
    nomad
    #vagrant
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
    # openshift
    awscli
    azure-cli
    # awscli2
    argocd
    ansible
    # tanka
    # cloud
    # eksctl
    # minikube
    kompose

    # RUST
    cargo
    cargo-edit
    rustc
    go

    # # BEAM
    rebar3
    elixir
    erlang
    gleam

    # NIX
    cachix

    # FE
    nodejs
    nodePackages.npm
    yarn
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bat = {
    enable = true;

    themes = {
      "tokyonight-moon" = {
        src = ./bat/tokyonight-moon.tmTheme;
        file = null; # Since the file is already at the correct path
      };
    };
    config = {
      theme = "tokyonight-moon";
    };
  };
  programs.fzf.enable = true;
  programs.gpg.enable = true;

  # MAYBE MOVE TO SHELL/TERMINAL module
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
}
