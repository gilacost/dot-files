{
  pkgs,
  ...
}:
#  TODO REVIEW ALL THESE PACKAGES
# check https://github.com/jmackie/dotfiles/blob/main/modules/tools/default.nix
let
  claudeCode = pkgs.stdenv.mkDerivation {
    pname = "claude-code";
    version = "0.2.29";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-0.2.29.tgz";
      sha256 = "1iKDtTE+cHXMW/3zxfsNFjMGMxJlIBzGEXWtTfQfSMM=";
    };

    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.makeWrapper
    ];

    installPhase = ''
      mkdir -p $out/lib/node_modules/@anthropic-ai/claude-code
      tar -xzf $src --strip-components=1 -C $out/lib/node_modules/@anthropic-ai/claude-code

      mkdir -p $out/bin
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/claude-code \
        --add-flags "$out/lib/node_modules/@anthropic-ai/claude-code/cli.mjs"
    '';

    meta = with pkgs.lib; {
      description = "Claude Code CLI tool";
      homepage = "https://www.anthropic.com/claude-code";
      mainProgram = "claude-code";
    };
  };
in
#mcp-proxy = import ./mcp-proxy.nix { inherit pkgs; };
{
  home.packages = with pkgs; [
    #mcp-hub
    #mcp-proxy
    #claude-code
    claudeCode
    nixos-generators
    cf-terraforming
    kas
    ssm-session-manager-plugin
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
    age
    git-crypt

    # LSP, LINTING AND FORMATTING
    hclfmt
    # elixir_ls
    # (callPackage (import ./elixir-ls.nix) {})
    erlang-ls
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
    #awscli
    azure-cli
    awscli2
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

  # home.file.".config/mcphub/servers.json".text = builtins.toJSON {
  #   mcpServers = {
  #     tidewave = {
  #       command = "${mcp-proxy}/bin/mcp-proxy";
  #       args = [ "http://localhost:4000/tidewave/mcp" ]; # 🔁 Replace `$PORT`
  #     };
  #   };
  # };

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
    enableZshIntegration = true;
  };

}
