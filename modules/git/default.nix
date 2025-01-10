{ ... }:
let
  gitconfig = {
    userEmail = "josepgiraltdlacoste@gmail.com";
    gpgKey = "CA5FC2044BDAA993";
    userName = "Josep Lluis Giralt D'Lacoste";
  };
in
{
  #TODO review lazygit
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
          commit-decoration-style = "bold yellow box";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-decoration-style = "bold yellow box";
          hunk-header-style = "bold yellow ul";
          plus-style = "#7aa2f7";
          minus-style = "#f7768e";
          minus-emph-style = "#bb9af7";
          plus-emph-style = "#9ece6a";
          commit-style = "bold magenta";
        };
      };
    };

    lfs.enable = true;

    userEmail = gitconfig.userEmail;
    userName = gitconfig.userName;

    signing = {
      key = gitconfig.gpgKey;
      signByDefault = true;
    };

    extraConfig = {
      "difftool \"nvr\"" = {
        cmd = "nvr -s -d $LOCAL $REMOTE";
      };
      "mergetool \"nvr\"" = {
        cmd = "nvr -s -d $LOCAL $BASE $REMOTE $MERGED -c 'wincmd J | wincmd ='";
      };
      diff = {
        tool = "nvr";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        tool = "nvr";
        conflictstyle = "diff3";
      };
      mergetool = {
        prompt = false;
      };
      pull.ff = "only";
      apply = {
        whitefix = "fix";
      };
      push = {
        default = "current";
      };
      rebase = {
        autosquash = true;
      };
      rerere = {
        enabled = true;
      }; # review
      core = {
        editor = "nvr -cc split --remote-wait";
      };
      alias = {
        ccount = "git rev-list --all --count";
        co = "checkout";
        l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)an>%Creset' --abbrev-commit --date=relative";
        recommit = "commit --amend -m";
        commend = "commit --amend --no-edit";
        here = ''!git init && git add . && git commit -m "Initialized a new repository"'';
        zip = "archive --format=tar.gz -o ../repo.tar.gz";
        plg = "log --graph --pretty=format:'%C(yellow)%h%Creset -%Cred%d%Creset %s %Cgreen| %cr %C(bold blue)| %an%Creset' --abbrev-commit --date=relative";
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
}
