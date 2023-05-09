{ pkgs, devenv, ... }: {
  #  TODO REVIEW ALL THESE PACKAGES
  # check https://github.com/jmackie/dotfiles/blob/main/modules/tools/default.nix
  home.packages = [ devenv ] ++ (with pkgs; [
    neovim-remote
    tree-sitter
    nix-prefetch-git
    subversionClient
    cmake

    act
    nodejs-slim-19_x

    dasel
    silver-searcher
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    unixtools.watch
    fortune
    fd
    jq
    yq
    btop
    ripgrep
    #   bind # review
    cloc

    glow
    wget
    tig
    tree
    imagemagick

    zsh-syntax-highlighting

    coreutils

    httpie

    peco

    nmap
    inetutils # common net tool package instead
    nodePackages.node2nix
    nodePackages.cspell
    # tanka
    sops
    git-crypt

    # lsp
    elixir_ls
    erlang-ls
    terraform-ls
    rnix-lsp
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    #  todo Json ls and tailwindcss

    rust-analyzer
    rustfmt

    hadolint
    nixfmt
    tflint
    # nodePackages.textlint
    nodePackages.prettier
    nodePackages.markdownlint-cli
    erlfmt
    shellcheck

    pre-commit

    postgresql
    #   # cloud
    #   awcli2
    #   azure-cli
    google-cloud-sdk
    linode-cli
    flyctl
    # openshift
    #
    #  # OPs
    #  # argocd
    #  # ansible
    terragrunt
    packer
    skopeo
    skaffold
    nomad
    vagrant
    # eksctl
    # minikube
    # kompose
    vault
    infracost
    dive
    kind
    terraform
    terragrunt
    kubectl
    kubernetes-helm
    google-cloud-sdk
    terraformer
    terraform-docs
    htop

    # programming languages
    # RUST
    cargo
    cargo-edit
    rustc
    go

    # # BEAM
    rebar3
    elixir
    erlang

    cachix

    # Python
    nodePackages.pyright
    python310Full
    python310Packages.grip
    python310Packages.autopep8
    python310Packages.numpy
    python310Packages.setuptools

    # FE
    nodejs
    nodePackages.npm
    yarn

    # Security
    _1password
    # _1password-gui
    git-credential-1password
  ]);

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.gpg.enable = true;

  # MAYBE MOVE TO SHELL/TERMINAL module
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
}
