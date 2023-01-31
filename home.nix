{ config, pkgs, lib, ... }:
let
  gitconfig = {
    userEmail = "josepgiraltdlacoste@gmail.com";
    gpgKey = "CA5FC2044BDAA993";
  };
in {

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  ############
  # Packages #
  ############

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    neovim-remote
    tree-sitter

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
    gh
    glow
    wget
    tig
    tree
    imagemagick

    zsh-syntax-highlighting

    coreutils

    httpie
    asdf-vm

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

    # BEAM
    rebar3
    elixir
    erlang

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
    git-credential-1password
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
        ccount = "git rev-list --all --count";
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
    ignores = [
      ".elixir_ls"
      "cover"
      "deps"
      "node_modules"
      ".direnv/"
      ".envrc"
      ".DS_Store"
    ];
  };

  ###################
  # SHELL/ZSH  ######
  ###################

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    history.extended = true;
    plugins = [
      {
        name = "zsh-fzf-tab";
        file = "fzf-tab.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "0c36bdcf6a80ec009280897f07f56969f94d377e";
          sha256 = "0ymp9ky0jlkx9b63jajvpac5g3ll8snkf8q081g0yw42b9hwpiid";
        };
      }
      {
        name = "catppuccin-zsh-syntax-highlighting";
        file = "catppuccin-zsh-syntax-highlighting.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "zsh-syntax-highlighting";
          rev = "938da69f1be3e7b34b8ff0bec662505c226c58a8";
          sha256 = "18yafns9d3hnw9j0qgaqyx2mn8xlj3kv9qnx7lhbs5nlgxcwdcm7";
          # 050klwq8pgvmp269pdlg673zyqh269ljkj69vyx6z2iw6qs51a42
        };
      }

    ];

    # Review prezto and pure options
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };

    initExtra = builtins.readFile ./conf.d/shell/functions.sh;

    sessionVariables = {
      DOCKER_BUILDKIT = 1;
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
      rm = "rm -i";
      cat = "bat";
      gcoi =
        "git branch --all | peco | sed 's/remotes\\/origin\\///g' | xargs git checkout";
      ghcoi =
        "gh pr list | peco | awk '{ NF-=1; print $NF}' | xargs git checkout";
    };
  };

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
      autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

      if has('nvim')
        let $GIT_EDITOR = 'nvr -cc split --remote-wait'
      endif

      function! RenameFile()
        let old_name = expand('%')
        let new_name = input('New file name: ', expand('%'), 'file')
        if new_name != '\' && new_name != old_name
          exec ':saveas ' . new_name
          exec ':silent !rm ' . old_name
          redraw!
        endif
      endfunction

      function! s:list_buffers()
          redir => list
          silent ls
          redir END
          return split(list, "\n")
      endfunction

      set noswapfile

      command! BD call fzf#run(fzf#wrap({
        \ 'source': s:list_buffers(),
        \ 'sink*': { lines -> s:delete_buffers(lines) },
        \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
        \ }))

      function! s:delete_buffers(lines)
        execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
      endfunction

      lua << EOF
        vim.g.lsp_elixir_bin = "${pkgs.elixir_ls}/bin/elixir-ls"
        ${builtins.readFile ./conf.d/editor/base.lua}
      	${builtins.readFile ./conf.d/editor/lsp.lua}
        ${builtins.readFile ./conf.d/editor/sets.lua}
        ${builtins.readFile ./conf.d/editor/terminal.lua}
        ${builtins.readFile ./conf.d/editor/treesitter.lua}
        ${builtins.readFile ./conf.d/editor/theme.lua}
        ${builtins.readFile ./conf.d/editor/telescope.lua}
        ${builtins.readFile ./conf.d/editor/lspkind.lua}
      EOF
    '';

    plugins = with pkgs;
      with pkgs.vimPlugins;
      let
        virt-column = vimUtils.buildVimPlugin {
          name = "virt-column";
          src = fetchFromGitHub {
            owner = "lukas-reineke";
            repo = "virt-column.nvim";
            rev = "fe3cff94710d648c57ac826fb846014903c76b00";
            sha256 = "0m5b180ijk63ci4g1c8j1hi5ga4z6jcwfq8hv5kfmwjgiycf3wsc";
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
        vim-vsnip
        vim-vsnip-integ
        vim-jsonnet

        # Appearance
        barbar-nvim
        catppuccin-nvim
        lspkind-nvim
        lualine-nvim
        nvim-web-devicons
        virt-column
        # vim-markdown

        # Navigation
        nerdtree
        vim-easymotion
        vim-startify
        telescope-nvim
        telescope-symbols-nvim
        trouble-nvim
        vim-cool
        vim-rooter

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
        cmp-nvim-lsp
        cmp-buffer
        cmp-nvim-lsp
        nvim-cmp
        nvim-lspconfig
        neoformat

        # Snippets
        vim-vsnip

        # Other
        # vim-wakatime
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
