{ config, pkgs, ... }: {

  programs.home-manager.enable = true;

  ############
  # Packages #
  ############

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    neovim-remote

    ripgrep
    silver-searcher
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    unixtools.watch
    fd
    jq
    yq
    htop
    ripgrep
    bind # review
    cloc
    gh
    glow
    peco
    wget
    tig
    tree
    telnet
    nodePackages.node2nix

    tanka
    sops
    git-crypt

    ### TO REVIEW
    # pkgs.coreutils
    # pkgs.pstree
    # pkgs.rename
    # pkgs.terminal-notifier
    # pkgs.html-tidy
    # pkgs.wxmac
    ### TO REVIEW

    # lsp
    terraform-ls
    rnix-lsp
    elixir_ls
    erlang-ls
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vim-language-server
    nodePackages.yaml-language-server

    # nodePackages_latest.yaml-language-server
    # sumneko-lua-language-server

    hadolint
    nixfmt
    nodePackages.prettier
    erlfmt
    go-jsonnet

    # cloud
    awscli
    azure-cli
    google-cloud-sdk
    linode-cli

    # OPs
    skaffold
    minikube
    kompose
    dive
    kind
    terraform
    kubectl
    kubernetes-helm
    google-cloud-sdk
    terraformer
    # fluxcd
    # brew install fluxcd/tap/flux

    rebar3

    # programming languages
    elixir
    erlang
    go

    # client
    yarn
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.enableFlakes = true;

  programs.bat.enable = true;

  programs.fzf.enable = true;

  programs.gpg.enable = true;

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  ###################
  # GIT        ######
  ###################

  programs.git = {
    enable = true;

    delta = {
      enable = true;
      options = {
        syntax-theme = "Monokai Extended Bright";
        features = "side-by-side line-numbers decorations";
        whitespace-error-style = "22 reverse";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
      };
    };

    lfs.enable = true;

    userEmail = "pep.g.dlacoste@erlang-solutions.com";
    userName = "Josep Lluis Giralt D'Lacoste";

    signing = {
      key = "695027416644669A";
      signByDefault = true;
    };

    extraConfig = {
      "difftool \"nvr\"" = { cmd = "nvr -s -d $LOCAL $REMOTE"; };
      "mergetool \"nvr\"" = {
        cmd = "nvr -s -d $LOCAL $BASE $REMOTE $MERGED -c 'wincmd J | wincmd ='";
      };
      diff = { tool = "nvr"; };
      init = { defaultBranch = "main"; };
      merge = {
        tool = "nvr";
        conflictstyle = "diff3";
      };
      mergetool = { prompt = false; };
      pull.ff = "only";
      apply = { whitefix = "fix"; };
      push = { default = "current"; };
      rebase = { autosquash = true; };
      rerere = { enabled = true; }; # review
      core = { editor = "nvr -cc split --remote-wait"; };
      alias = {
        co = "checkout";
        l =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)an>%Creset' --abbrev-commit --date=relative";
        recommit = "commit --amend -m";
        commend = "commit --amend --no-edit";
        here = ''
          !git init && git add . && git commit -m "Initialized a new repository"'';
        zip = "archive --format=tar.gz -o ../repo.tar.gz";
        plg =
          "log --graph --pretty=format:'%C(yellow)%h%Creset -%Cred%d%Creset %s %Cgreen| %cr %C(bold blue)| %an%Creset' --abbrev-commit --date=relative";
        fresh = "filter-branch --prune-empty --subdirectory-filter";
      };
    };
    ignores =
      [ ".elixir_ls" "cover" "deps" "node_modules" ".direnv/" ".envrc" ];
  };

  ###################
  # SHELL/ZSH  ######
  ###################

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    history.extended = true;

    # Review prezto and pure options
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };

    initExtra = builtins.readFile ./conf.d/shell/functions.sh;

    sessionVariables = {
      ERL_AFLAGS = "-kernel shell_history enabled";
      NIX_PATH =
        "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow";
    };

    shellAliases = {
      # git
      gbr = ''git branch | grep -v "master" | xargs git branch -D'';
      gcoi = ''
        git branch --all | peco | sed 's/remotes/origin//g' | xargs git checkout
      '';
      g = "git";
      gundo = "git reset --soft HEAD~1";
      gfpl = "git push --force-with-lease";
      ga = "git add";
      gst = "git status";
      gai = "gsina | xargs git add";
      gaip = "gsina | xargs -o git add -p";
      gb = "git branch";
      gbdi = "git branch | peco | xargs git branch -d";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gdi = "gsina | xargs -o git diff";
      gf = "git fetch --all";
      # alias gh='git stash'
      gpf = "git push --force-with-lease";
      ghl = "git stash list";
      ghp = "git stash pop";
      git = "noglob git";
      gp = "git push";
      gpo = "git push origin";
      gpot = "git push origin --tags";
      gpuo = "git push -u origin `git rev-parse --abbrev-ref HEAD`";
      gr = "git reset";
      gri = "gsina | git reset";
      gs = "git status";
      gull = "git pull";
      grc = "git rev-list -n 1 HEAD --";
      gapa = "git add --patch";
      # OPS
      dockerbash =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/bash";
      dockersh =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/sh";
      dockerrm =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker rm -f {}";
      dockerlogs =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker logs -f {}";
      dockerrmiall = ''docker rmi "$(docker images -a -q)"'';
      dockerrmall = ''docker rm "$(docker ps -a -q)"'';
      dockerstopall = ''docker stop "$(docker ps -a -q)"'';
      # KUBE
      kubelogs =
        "kubectl get pods | sed -n '1!p' | peco | sed 's/ .*//g' | xargs -I{} -ot kubectl logs -f {}";
      kubeinitcontext =
        "aws eks --region $AWS_REGION update-kubeconfig --name $1";
      # RAND
      rm = "rm -i";
      cat = "bat";
    };
  };
  ### yaml for image  kubectl run kiada --image=luksa/kiada:0.1 --dry-run=client -o yaml > mypod.yaml
  # kubectl run --image=tutum/curl -it --restart=Never --rm client-pod curl 10.244.2.4:8080

  ###################
  # EDITOR   ########
  ###################

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    # TODO replace fzf for telescope

    extraConfig = ''
      ${builtins.readFile ./conf.d/editor/init.vim}
      ${builtins.readFile ./conf.d/editor/sets.vim}
      ${builtins.readFile ./conf.d/editor/terminal.vim}
      ${builtins.readFile ./conf.d/editor/git.vim}
      ${builtins.readFile ./conf.d/editor/fzf.vim}
      ${builtins.readFile ./conf.d/editor/projections.vim}
      ${builtins.readFile ./conf.d/editor/init-lua.vim}
      ${builtins.readFile ./conf.d/editor/telescope.vim}
      ${builtins.readFile ./conf.d/editor/lspkind.vim}
      ${(import ./modules/lsp.nix) pkgs}
    '';

    plugins = with pkgs;
      with pkgs.vimPlugins;
      let
        nvim-treesitter = vimUtils.buildVimPlugin {
          name = "nvim-treesitter";
          src = fetchFromGitHub {
            owner = "nvim-treesitter";
            repo = "nvim-treesitter";
            rev = "1e4c846d01561821a737d08a6a5e2ac16d19c332";
            sha256 = "0cl2h599i4xmvgm4k8cliiz43qz6xnirh1zb8sfibdnw0fbqfpa5";
          };
        };
      in [
        vim-test

        ###REVIEW###
        # vim-rooter
        # vim-wakatime
        # vim-cool
        # indentLine
        ##REVIEW###

        # Git
        vim-fugitive
        vim-gitgutter
        vim-rhubarb # review

        # Programming
        emmet-vim
        vim-nix
        vim-javascript
        vim-jsx-typescript
        vim-graphql
        emmet-vim
        rust-vim
        vim-terraform
        vim-orgmode
        vim-elixir
        vim-lua
        nvim-treesitter
        nvim-treesitter-refactor
        nvim-treesitter-textobjects
        vim-jsonnet

        # Appearence
        vim-one
        vim-airline
        vim-airline-themes
        vim-devicons
        lspkind-nvim
        nvim-web-devicons

        # Navigation
        nerdtree
        vim-easymotion
        vim-startify
        telescope-nvim
        telescope-symbols-nvim
        trouble-nvim
        vim-rooter
        vim-cool

        # Pope
        vim-commentary
        vim-surround
        vim-commentary
        vim-unimpaired
        vim-projectionist
        vim-speeddating # review this
        vim-vinegar
        vim-abolish

        # Linting / Fixing / Lsp
        lspsaga-nvim
        nvim-compe
        nvim-lspconfig
        neoformat
        # ale

        # Snippets
        vim-vsnip

        # Other
        vim-wakatime
      ];
  };

  ###########
  # Firefox #
  ###########
  programs.firefox.enable = true;
  # Handled by the Homebrew module
  # This populates a dummy package to satsify the requirement
  programs.firefox.package = pkgs.runCommand "firefox-0.0.0" { } "mkdir $out";

  programs.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    tridactyl
    onepassword-password-manager
  ];

  programs.firefox.profiles = let
    userChrome = builtins.readFile ./conf.d/userChrome.css;
    settings = {
      "app.update.auto" = false;
      "browser.startup.homepage" = "https://lobste.rs";
      "browser.search.region" = "GB";
      "browser.search.countryCode" = "GB";
      "browser.search.isUS" = false;
      "browser.ctrlTab.recentlyUsedOrder" = false;
      "browser.newtabpage.enabled" = false;
      "browser.bookmarks.showMobileBookmarks" = true;
      "browser.uidensity" = 1;
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.update1" = true;
      "distribution.searchplugins.defaultLocale" = "en-GB";
      "general.useragent.locale" = "en-GB";
      # "identity.fxaccounts.account.device.name" = config.networking.hostName;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
      "reader.color_scheme" = "sepia";
      "services.sync.declinedEngines" = "addons,passwords,prefs";
      "services.sync.engine.addons" = false;
      "services.sync.engineStatusChanged.addons" = true;
      "services.sync.engine.passwords" = false;
      "services.sync.engine.prefs" = false;
      "services.sync.engineStatusChanged.prefs" = true;
      "signon.rememberSignons" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  in {
    home = {
      inherit settings;
      inherit userChrome;
      id = 0;
    };

    work = {
      inherit userChrome;
      id = 1;
      settings = settings // {
        "browser.startup.homepage" = "about:blank";
        "browser.urlbar.placeholderName" = "Google";
      };
    };
  };
}
