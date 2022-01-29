{ config, pkgs, lib, ... }:
let
  # _ = builtins.trace config.networking.hostName;
  # gitconfig = (lib.mkIf config.networking.hostName == "pepesl" {
  gitconfig = {
    userEmail = "josepgiraltdlacoste@gmail.com";
    gpgKey = "1710D238E7756AB4";
  };
  # }) (lib.mkIf config.networking.hostName != "pepesl" {
  # userEmail = "josepgiraltdlacoste@gmail.com";
  # gpgKey = "1710D238E7756AB4";
  # });

in {

  programs.home-manager.enable = true;

  ############
  # Packages #
  ############

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    neovim-remote

    silver-searcher
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    unixtools.watch
    fortune
    fd
    jq
    yq
    htop
    ripgrep
    bind # review
    cloc
    gh
    glow
    wget
    tig
    tree
    gnumake

    nmap
    telnet # common net tool package instead
    nodePackages.node2nix
    # here
    tanka
    # sops
    git-crypt

    # lsp
    terraform-ls
    rnix-lsp
    elixir_ls
    erlang-ls
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vim-language-server
    nodePackages.yaml-language-server
    tree-sitter

    hadolint
    nixfmt
    nodePackages.prettier
    erlfmt
    go-jsonnet

    pre-commit

    # cloud
    awscli
    azure-cli
    google-cloud-sdk
    linode-cli
    # openshift

    postgresql

    postgresql

    # OPs
    argocd
    # terragrunt
    skopeo
    skaffold
    # minikube
    kompose
    dive
    # kind
    terraform
    # kubectl
    # kubernetes-helm
    google-cloud-sdk
    terraformer

    rebar3
    # programming languages
    elixir
    erlang
    asdf-vm
    go

    # FE
    yarn
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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

  programs.lazygit.enable = true;

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

    userEmail = gitconfig.userEmail;
    userName = "Josep Lluis Giralt D'Lacoste";

    signing = {
      key = gitconfig.gpgKey;
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
    plugins = [{
      name = "zsh-fzf-tab";
      file = "fzf-tab.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "0c36bdcf6a80ec009280897f07f56969f94d377e";
        sha256 = "0ymp9ky0jlkx9b63jajvpac5g3ll8snkf8q081g0yw42b9hwpiid";
      };
    }];

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
      # gcoi =
      #   "git branch --all | fzf | sed '''s/remotes''\/origin''\///g' | xargs git checkout";
      g = "git";
      gundo = "git reset --soft HEAD~1";
      gfpl = "git push --force-with-lease";
      ga = "git add";
      gst = "git status";
      gai = "gsina | xargs git add";
      gaip = "gsina | xargs -o git add -p";
      gb = "git branch";
      gbdi = "git branch | fzf --layout=reverse -m | xargs git branch -d";
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
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/bash";
      dockersh =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/sh";
      dockerrm =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker rm -f {}";
      dockerlogs =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker logs -f {}";

      dockerstop =
        "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker stop {}";
      dockerrmiall = ''docker rmi "$(docker images -a -q)"'';
      dockerrmall = ''docker rm "$(docker ps -a -q)"'';
      dockerstopall = ''docker stop "$(docker ps -a -q)"'';
      # KUBE
      kubelogs =
        "kubectl get pods --all-namespaces | sed -n '2!p' | fzf --layout=reverse -m | awk '{print $1, $2}' | xargs -n2 -ot sh -c 'kubectl logs -f \${1} -n \${0}'";
      kuberm =
        "kubectl get pods --all-namespaces | sed -n '2!p' | fzf --layout=reverse -m | awk '{print $1, $2}' | xargs -n2 -ot sh -c 'kubectl delete pod \${1} -n \${0}'";
      kubesh =
        "kubectl get pods --all-namespaces | sed -n '1!p' | fzf --layout=reverse -m | awk '{print $1, $2}' | xargs -n2 -ot sh -c 'kubectl exec -it \${1} -n \${0} -- /bin/sh'";
      # kubeinitcontext =
      #   "aws eks --region $AWS_REGION update-kubeconfig --name $1";
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
      ${builtins.readFile ./conf.d/editor/theme.vim}
    '';

    plugins = with pkgs;
      with pkgs.vimPlugins;
      let
        catppuccino-nvim = vimUtils.buildVimPlugin {
          name = "catppuccino-nvim";
          src = fetchFromGitHub {
            owner = "Pocco81";
            repo = "Catppuccino.nvim";
            rev = "5f35851efa249eafd459d7691f52732295ed669e";
            sha256 = "1p1s8zqd1mn7s3v8d5lh9mb3yii0qqvz153hz4vzlw8qz2jzhhhx";
          };
        };
        nvim-treesitter = vimUtils.buildVimPlugin {
          name = "nvim-treesitter";
          src = fetchFromGitHub {
            owner = "nvim-treesitter";
            repo = "nvim-treesitter";
            rev = "3ee34749bcd8a3bd1293b021f4e7d01c4b3b650c";
            sha256 = "161rx0fsjdqqlwp20xinkbkdq864k59ybplcfsliv4w1ykmpy4r4";
          };
        };
        cmp-buffer = vimUtils.buildVimPlugin {
          name = "cmp-buffer";
          src = fetchFromGitHub {
            owner = "hrsh7th";
            repo = "cmp-buffer";
            rev = "5742a1b18ebb4ffc21cd07a312bf8bacba4c81ae";
            sha256 = "0nh53gqzbm500rvwc59hbl1sg12qzpk8za3z6rvsg04s6rqv479f";
          };
        };

        cmp-nvim-lsp = vimUtils.buildVimPlugin {
          name = "cmp-nvim-lsp";
          src = fetchFromGitHub {
            owner = "hrsh7th";
            repo = "cmp-nvim-lsp";
            rev = "6d991d0f7beb2bfd26cb0200ef7bfa6293899f23";
            sha256 = "0yq80sww53blvp0zq40a1744mricf4v3qafxrry4x812fv4bh8mk";
          };
        };

        nvim-comp = vimUtils.buildVimPlugin {
          name = "nvim-comp";
          src = fetchFromGitHub {
            owner = "hrsh7th";
            repo = "nvim-cmp";
            rev = "24406f995ea20abba816c0356ebff1a025c18a72";
            sha256 = "142r41483xx7yw1gr4g1xi3rvzlprqwc72bq8rky0ys6mq50d7ic";
          };
          buildInputs = [ stylua ];
        };

        vsnip = vimUtils.buildVimPlugin {
          name = "vim-vsnip";
          src = fetchFromGitHub {
            owner = "hrsh7th";
            repo = "vim-vsnip";
            rev = "87d144b7451deb3ab55f1a3e3c5124cfab2b02fa";
            sha256 = "17gw992xvxsa6wyirah17xbsdi2gl4lif8ibvbs7dwagnkv01vyb";
          };
        };

        vsnip-integ = vimUtils.buildVimPlugin {
          name = "vim-vsnip-integ";
          src = fetchFromGitHub {
            owner = "hrsh7th";
            repo = "vim-vsnip-integ";
            rev = "8f94cdd9ca6c3e6c328edaf22029f1bf17f3d1c5";
            sha256 = "1wh44m7jn1s7jyk0g9flf2qhkqgcl5amfi5w7dwjqkr8z495r29h";
          };
        };

      in [
        vim-test

        ###REVIEW###
        # indentLine
        ##REVIEW###

        # Git
        vim-fugitive
        vim-gitgutter
        vim-rhubarb # review

        # Programming
        emmet-vim
        nvim-treesitter
        nvim-treesitter-refactor
        nvim-treesitter-textobjects
        vim-elixir
        cmp-buffer
        cmp-nvim-lsp
        nvim-comp
        vsnip
        vsnip-integ
        vim-jsonnet

        # Appearance
        barbar-nvim
        catppuccino-nvim
        lualine-nvim
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
        # vim-rooter
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
        vim-markdown

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
  # This populates a dummy package to satisfy the requirement
  programs.firefox.package = pkgs.runCommand "firefox-0.0.0" { } "mkdir $out";

  programs.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons;
    [
      # tridactyl
      onepassword-password-manager
    ];

  programs.firefox.profiles = let
    userChrome = builtins.readFile ./conf.d/userChrome.css;
    settings = {
      "app.update.auto" = false;
      "browser.startup.homepage" = "http://elixirweekly.net/";
      "browser.search.region" = "GB";
      "browser.search.countryCode" = "GB";
      "browser.search.isUS" = false;
      "browser.ctrlTab.recentlyUsedOrder" = false;
      "browser.newtabpage.enabled" = false;
      "browser.bookmarks.showMobileBookmarks" = true;
      "browser.uidensity" = 1;
      "browser.cache.disk.enable" = false;
      "devtools.cache.disabled" = true;
      "devtools.theme dark" = "dark";
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
      "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
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
