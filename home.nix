{ pkgs, lib, ... }:
{

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  imports = [
    ./modules/gh
    ./modules/git
    ./modules/zsh
    ./modules/tools
    ./modules/editor
  ];

  home.file.".config/peco/config.json" = {
    text = ''
      {
          "Style": {
              "Basic": ["on_default", "default"],
              "SavedSelection": ["bold", "on_blue", "white"],
              "Selected": ["underline", "on_cyan", "black"],
              "Query": ["cyan", "bold"],
              "Matched": ["blue", "bold"]
          },
          "Use256Color": true
      }
    '';
  };

  # mise config: create writable symlink to git repo (not nix store)
  # This allows mise to modify the config when upgrading
  home.activation.linkMiseConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/mise
    rm -f $HOME/.config/mise/config.toml
    ln -sf $HOME/Repos/dot-files/conf.d/mise/config.toml $HOME/.config/mise/config.toml
  '';

  # Claude config: writable symlinks so Claude Code can update settings and memories
  home.activation.linkClaudeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DOTFILES="$HOME/Repos/dot-files/conf.d/claude"
    CLAUDE="$HOME/.claude"

    mkdir -p "$CLAUDE"
    rm -f "$CLAUDE/settings.json"
    ln -sf "$DOTFILES/settings.json" "$CLAUDE/settings.json"

    rm -f "$CLAUDE/CLAUDE.md"
    ln -sf "$DOTFILES/CLAUDE.md" "$CLAUDE/CLAUDE.md"

    rm -f "$CLAUDE/statusline-command.sh"
    ln -sf "$DOTFILES/statusline-command.sh" "$CLAUDE/statusline-command.sh"

    link_memory() {
      local project_dir="$1"
      local memory_name="$2"
      mkdir -p "$CLAUDE/projects/$project_dir"
      rm -rf "$CLAUDE/projects/$project_dir/memory"
      ln -sf "$DOTFILES/memories/$memory_name" "$CLAUDE/projects/$project_dir/memory"
    }

    link_memory "-Users-pepo-Repos-dot-files"                                            "dot-files"
    link_memory "-Users-pepo-Repos-automations"                                          "automations"
    link_memory "-Users-pepo-Repos-customers-digital-onboarding-bikeshed"                "bikeshed"
    link_memory "-Users-pepo-Repos-customers-digital-onboarding-digital-onboarding"      "digital-onboarding"
    link_memory "-Users-pepo-Repos-customers"                                            "customers"
  '';

  home.file.".config/nvim.session" = {
    text = ''
      ${builtins.readFile ./conf.d/terminal/nvim.session}
    '';
  };

  home.file.".config/kitty/kitty.conf" = {
    source = ./conf.d/terminal/kitty.conf;
  };

  home.file.".config/ghostty/config" = {
    source = ./conf.d/terminal/ghostty;
  };

}
