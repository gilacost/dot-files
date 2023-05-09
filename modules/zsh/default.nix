# TODO pass shell from flake and remove it from functions.sh{ SHELL, EDITOR, PAGER, ... }:
{ pkgs, ... }: {
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

    initExtra = builtins.readFile ./functions.sh;

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
      dockerrmiall = "docker rmi $(docker images -a -q)";
      dockerrmall = "docker rm $(docker ps -a -q)";
      dockerstopall = "docker stop $(docker ps -a -q)";
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
}
