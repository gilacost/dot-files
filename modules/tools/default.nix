{ pkgs, devenv, ... }: {
  #  TODO REVIEW ALL THESE PACKAGES
  # check https://github.com/jmackie/dotfiles/blob/main/modules/tools/default.nix
  home.packages = [ devenv ] ++ (with pkgs; [
    neovim-remote
    tree-sitter

    # TO REVIEW
    # cmake
    # act
    # bind 
    # coreutils

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
    elixir_ls
    erlang-ls
    terraform-ls
    rnix-lsp
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    rust-analyzer
    rustfmt
    hadolint
    nixfmt
    tflint
    nodePackages.prettier
    erlfmt
    shellcheck
    nodePackages.markdownlint-cli
    nodePackages.cspell
    nodePackages.pyright
    # nodePackages.textlint
    # todo Json ls and tailwindcss

    # CLOUD SDKS, OPS TOOLS AND WORKFLOW
    # pre-commit
    terragrunt
    packer
    skopeo
    skaffold
    nomad
    vagrant
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
    # awcli2
    # azure-cli
    # argocd
    # ansible
    # tanka
    # cloud
    # eksctl
    # minikube
    # kompose

    # RUST
    cargo
    cargo-edit
    rustc
    go

    # # BEAM
    rebar3
    elixir
    erlang

    # PYTHON
    python310Full
    python310Packages.grip
    python310Packages.autopep8
    python310Packages.numpy
    python310Packages.setuptools

    # NIX
    cachix

    # FE
    nodejs
    nodePackages.npm
    yarn

    # SECURITY
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
