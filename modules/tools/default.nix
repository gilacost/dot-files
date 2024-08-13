{ pkgs, devenv, ... }:
{
  #  TODO REVIEW ALL THESE PACKAGES
  # check https://github.com/jmackie/dotfiles/blob/main/modules/tools/default.nix
  # home.packages = [ devenv ] ++ (with pkgs; [
  home.packages = with pkgs; [

    nixos-generators
    neovim-remote
    tree-sitter
    p7zip
    xorriso
    socat
    ffmpeg_7
    hping
    iperf
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
    zsh-syntax-highlighting
    cloc
    nodePackages.node2nix

    postgresql
    htop

    dasel
    silver-searcher
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
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
    elixir_ls
    erlang-ls
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
    lexical

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

    # SECURITY
    _1password
    # https://github.com/NixOS/nixpkgs/issues/222991
    # I've been trying to connect 1password-cli with 1password-gui for a long time
    # now and it has not been possible. Ideally, I would like to use 1password-cli
    # to handle ssh-keys and gihub tokens, I think this is possible with nixos but 
    # not with darwin. When you install 1password-gui it installs it the wrong 
    # path and I have not been able to find a way to change it, in this scenario
    # I am lost.  
    # /nix/store/kyxf3qrz6v4bmcdab56zgyr5myfhl23w-1password-8.10.4/Applications/

    # _1password-gui
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bat = {
    enable = true;
    #theme = "T";
  };
  programs.fzf.enable = true;
  programs.gpg.enable = true;

  # MAYBE MOVE TO SHELL/TERMINAL module
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
}
