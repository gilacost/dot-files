# TODO pass shell from flake and remove it from functions.sh{ SHELL, EDITOR, PAGER, ... }:
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

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

    ];

    # Review prezto and pure options
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };
    initContent = builtins.readFile ./functions.sh;

    # mise activation - must come after other init
    initExtra = ''
      # Activate mise for tool version management
      eval "$(mise activate zsh)"
    '';

    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      DOCKER_BUILDKIT = 1;
      TMPDIR = "$HOME/nix-temp";
      ERL_AFLAGS = "-kernel shell_history enabled";
      NIX_PATH = "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      PATH = "$HOME/Repos/dot-files/scripts:$PATH";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow";
      # FZF Theme - change "dark" to "light" to switch themes
      FZF_DEFAULT_OPTS =
        let
          theme = "dark"; # Change to "light" for light theme
          darkTheme = ''
            --highlight-line \
            --info=inline-right \
            --ansi \
            --layout=reverse \
            --border=none
            --color=bg+:#2d3f76 \
            --color=bg:#1e2030 \
            --color=border:#589ed7 \
            --color=fg:#c8d3f5 \
            --color=gutter:#1e2030 \
            --color=header:#ff966c \
            --color=hl+:#65bcff \
            --color=hl:#65bcff \
            --color=info:#545c7e \
            --color=marker:#ff007c \
            --color=pointer:#ff007c \
            --color=prompt:#65bcff \
            --color=query:#c8d3f5:regular \
            --color=scrollbar:#589ed7 \
            --color=separator:#ff966c \
            --color=spinner:#ff007c \
          '';
          lightTheme = ''
            --highlight-line \
            --info=inline-right \
            --ansi \
            --layout=reverse \
            --border=none
            --color=bg+:#b7c1e3 \
            --color=bg:#e1e2e7 \
            --color=border:#2e7de9 \
            --color=fg:#3760bf \
            --color=gutter:#e1e2e7 \
            --color=header:#b15c00 \
            --color=hl+:#2e7de9 \
            --color=hl:#2e7de9 \
            --color=info:#8990b3 \
            --color=marker:#f52a65 \
            --color=pointer:#f52a65 \
            --color=prompt:#2e7de9 \
            --color=query:#3760bf:regular \
            --color=scrollbar:#2e7de9 \
            --color=separator:#b15c00 \
            --color=spinner:#f52a65 \
          '';
        in
          if theme == "light" then lightTheme else darkTheme;
      _ZO_FZF_OPTS = "$FZF_DEFAULT_OPTS --height=40% --layout=reverse --border --margin=1 --padding=1";
    };

    shellAliases = {
      # latest release
      latest_elixir = "get_latest_release elixir-lang/elixir";
      latest_terraform = "get_latest_release hashicorp/terraform";
      latest_elixir_ls = "get_latest_release elixir-lsp/elixir-ls";
      latest_erlang = "get_latest_release erlang/otp";
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
      dockerbash = "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/bash";
      dockersh = "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker exec -ti {} /bin/sh";
      dockerrm = "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker rm -f {}";
      dockerlogs = "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker logs -f {}";

      dockerstop = "docker ps --format '{{.ID}}: {{.Image}} {{.Names}}' | fzf --layout=reverse -m | sed 's/: .*//g' | xargs -I{} -ot docker stop {}";
      dockerrmiall = "docker rmi $(docker images -a -q)";
      dockerrmall = "docker rm $(docker ps -a -q)";
      dockerstopall = "docker stop $(docker ps -a -q)";
      # ECS/AWS (use ECS_CLUSTER and AWS_REGION env vars)
      ecssh = "CLUSTER=\${ECS_CLUSTER} && REGION=\${AWS_REGION} && SELECTED=$(aws ecs list-tasks --cluster $CLUSTER --desired-status RUNNING --region $REGION --query 'taskArns[]' --output text | xargs aws ecs describe-tasks --cluster $CLUSTER --region $REGION --tasks --query 'tasks[].[taskArn,group,containers[0].name]' --output text | awk '{split(\$1,a,\"/\"); print a[length(a)] \": \" \$2 \" \" \$3}' | fzf --layout=reverse -m) && TASK=$(echo \$SELECTED | awk '{print \$1}' | sed 's/://g') && CONTAINER=$(echo \$SELECTED | awk '{print \$NF}') && aws ecs execute-command --cluster $CLUSTER --task \$TASK --container \$CONTAINER --command /bin/bash --interactive --region $REGION";
      awslogs = "REGION=\${AWS_REGION} && aws logs describe-log-groups --region $REGION --query 'logGroups[*].logGroupName' --output text | tr '\t' '\n' | fzf --layout=reverse -m | xargs -I{} -ot aws logs tail {} --follow --region $REGION";
      # KUBE
      kubelogs = "kubectl get pods --all-namespaces | sed -n '2!p' | fzf --layout=reverse -m | awk '{print $1, $2}' | xargs -n2 -ot sh -c 'kubectl logs -f \${1} -n \${0}'";
      kuberm = "kubectl get pods --all-namespaces | sed -n '2!p' | fzf --layout=reverse -m | awk '{print $1, $2}' | xargs -n2 -ot sh -c 'kubectl delete pod \${1} -n \${0}'";
      kubesh = "kubectl get pods --all-namespaces | sed -n '1!p' | fzf --layout=reverse -m | awk '{print $1, $2}' | xargs -n2 -ot sh -c 'kubectl exec -it \${1} -n \${0} -- /bin/sh'";
      rm = "rm -i";
      cat = "bat";
      gcoi = "git branch --all | peco | sed 's/remotes\\/origin\\///g' | xargs git checkout";
      ghcoi = "gh pr list | peco | awk '{ NF-=1; print $NF}' | xargs git checkout";
      ip = "ipconfig getifaddr en0";
      # Enhanced navigation aliases
      ff = "fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=header,grid --line-range :300 {}'";
      fdir = "fd --type d --hidden --exclude .git | fzf --preview 'tree -C {} | head -100'";
      fproj = "fd --type d --exact-depth 2 . ~/Repos | fzf --preview 'ls -la {}'";
      z = "zoxide query -i";
      lg = "lazygit";
    };
  };
}
