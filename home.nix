{ config, pkgs, ... }:
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  programs.home-manager.enable = true;

  home.username = "pepo";
  home.homeDirectory = "/Users/pepo";
  home.stateVersion = "21.11";

  ############
  # Packages #
  ############

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    neovim-remote
    ripgrep
    silver-searcher
    (nerdfonts.override {
      fonts = [
        "Iosevka"
      ];
    })
    # montserrat
    fd
    jq
    htop
    ripgrep
    bind # what whas this for ?
    cloc
    gh
    glow
    peco
    wget
    tig
    tree

    ### TO REVIEW
      # pkgs.coreutils
      # pkgs.kubectl
      # pkgs.pre-commit
      # pkgs.pstree
      # pkgs.rename
      # pkgs.telnet
      # pkgs.terminal-notifier
      # pkgs.html-tidy
      # pkgs.watch
      # pkgs.wxmac
    ### TO REVIEW

    # IASS
    terraform

    # linting/fixing
    yamllint # review and move to node packages
    hadolint
    # prettier
    # writegood
    # ansible-lint
    tflint
    rustfmt
    nixfmt
    # elm-format

    # cloud
    awscli
    azure-cli
    google-cloud-sdk

    # programming languages
    elixir
    erlang
  ];

  programs.bat.enable = true;

  programs.fzf.enable = true;

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
      enable= true;
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

    # interactive.diffFilter = "delta --color-only";

    # [apply] whitespace = fix
    # [push] default = current
    # [rebase] autosquash = true
    # [rerere] enabled = true
    # [core]
    #   excludesfile = ~/.gitignore
    #   autocrlf = input
    # 	editor = nvr -cc split --remote-wait
    # [core]      pager = delta

    lfs.enable = true;
    # todo with mkoption
    # https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix#L168
    # alias = {
    #     co = "checkout";
    #     l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)an>%Creset' --abbrev-commit --date=relative";
    #     recommit = "commit --amend -m";
    #     commend = "commit --amend --no-edit";
    #     here = "!git init && git add . && git commit -m \"Initialized a new repository\"";
    #     search = "grep";
    #     who = "blame";
    #     zip = "archive --format=tar.gz -o ../repo.tar.gz";
    #     lonely = "clone --single-branch --branch";
    #     plg = "log --graph --pretty=format:'%C(yellow)%h%Creset -%Cred%d%Creset %s %Cgreen| %cr %C(bold blue)| %an%Creset' --abbrev-commit --date=relative";
    #     fresh = "filter-branch --prune-empty --subdirectory-filter";
    # };

    userEmail = "josepgiraltdlacoste@gmail.com";
    userName = "Josep Giralt D'Lacoste";
    # signing = {
    #   key = "9A8F06C7265E82FB";
    #   signByDefault = true;
    # };
    # commit = { gpgsign = true} ;
    # gpg.program = gpg;


    extraConfig = {
      "difftool \"nvr\"" = { cmd = "nvr -s -d $LOCAL $REMOTE"; };
      "mergetool \"nvr\"" = {
        cmd = "nvr -s -d $LOCAL $BASE $REMOTE $MERGED -c 'wincmd J | wincmd ='";
      };
      delta.features = "side-by-side line-numbers decorations";
      diff = { tool = "nvr"; };
      init = { defaultBranch = "main"; };
      merge = {
        tool = "nvr";
        conflictstyle = "diff3";
      };
      mergetool = { prompt = false; };
      pull.ff = "only";
    };
    ignores = [ ".elixir_ls" "cover" "deps" "node_modules" ];
  };

  ###################
  # SHELL/ZSH  ######
  ###################

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    history.extended = true;

    # review prezto and pure options
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };

    initExtra = ''
    if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
      if [ -x "$(command -v nvr)" ]; then
        # alias nvim=nvr
        export EDITOR='nvr'
      else
        export EDITOR='echo "No nesting!"'
      fi
    fi
    export VISUAL=$EDITOR
    alias e=$EDITOR

    unsetopt BEEP
    '';
   # initExtraBeforeCompInit = builtins.readFile ./functions.zsh;

   sessionVariables = {
     ERL_AFLAGS = "-kernel shell_history enabled";
     KITTY_CONFIG_DIRECTORY= "~/.config/kitty";
     NIX_PATH= "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
     FZF_DEFAULT_COMMAND="rg --files --hidden --follow";
     # export VIMDATA=~/.local/share/$EDITOR
   };


   shellAliases = {
    # GIT
    gbr = "git branch | grep -v \"master\" | xargs git branch -D";
    gcoi = "git branch --all | peco | sed 's/remotes\/origin\///g' | xargs git checkout";
    g="git";
    ga="git add";
    gst="git status";
    gai="gsina | xargs git add";
    gaip="gsina | xargs -o git add -p";
    gb="git branch";
    gbdi="git branch | peco | xargs git branch -d";
    gc="git commit";
    gco="git checkout";
    gd="git diff";
    gdi="gsina | xargs -o git diff";
    gf="git fetch --all";
    # alias gh='git stash'
    ghl="git stash list";
    ghp="git stash pop";
    git="noglob git";
    gl="git log";
    gp="git push";
    gpo="git push origin";
    gpot="git push origin --tags";
    gpuo="git push -u origin `git rev-parse --abbrev-ref HEAD`";
    gr="git reset";
    gri="gsina | git reset";
    gs="git status";
    gull="git pull";
    grc="git rev-list -n 1 HEAD --";
    gapa="git add --patch";
    # DOCKER
    dockerbash="docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/bash";
    dockersh="docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/sh";
    dockerrm="docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker rm -f {}";
    dockerlogs="docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | peco | sed 's/: .*//g' | xargs -I{} -ot docker logs -f {}";
    dockerrmiall="docker rmi \"$(docker images -a -q)\"";
    dockerrmall="docker rm \"$(docker ps -a -q)\"";
    dockerstopall="docker stop \"$(docker ps -a -q)\"";
    # KUBE
    kubelogs="kubectl get pods | sed -n '1!p' | peco | sed 's/ .*//g' | xargs -I{} -ot kubectl logs -f {}";
    kubeinitcontext="aws eks --region $AWS_REGION update-kubeconfig --name $1";
    # RAND
    rm="rm -i";
    cat="bat";
    };
  };

  ###################
  # EDITOR   ########
  ###################

  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
    vimAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    extraConfig = ''
      ${builtins.readFile ./init.vim}
      ${builtins.readFile ./init.lua}
    '';


    plugins = with pkgs.vimPlugins; [
      vim-test
      # vim-dispatch # is this necessary?
      # vim-dispatch-neovim # is this necessary?

      ##REVIEW###
      # vim-rooter
      # vim-wakatime
      # vim-cool
      # indentLine
      # " Plug 'https://github.com/gilacost/ale.git', { 'branch': 'allow-erlfmt-as-fixer' }
      # " Plug 'dense-analysis/ale', { 'tag': 'v2.7.0' }
      # Plug 'dense-analysis/ale'
      # Plug 'gcmt/taboo.vim'
      # Plug 'SirVer/ultisnips'
      ##REVIEW###

      # Git
      vim-fugitive
      vim-gitgutter
      vim-rhubarb #review

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

      # appearence
      vim-one
      vim-airline
      vim-airline-themes
      vim-devicons

      # navigation
      nerdtree
      vim-easymotion
      vim-startify
      fzf-vim

      # pope
      vim-commentary
      vim-surround
      vim-commentary
      vim-unimpaired
      vim-projectionist
      vim-speeddating #review this
      vim-vinegar
      vim-abolish

      # linting / fixing / lsp
      ale
      lspsaga-nvim
      nvim-compe
      nvim-lspconfig
    ];
  };
}
