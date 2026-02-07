{ claudeCodeSrc, pkgs, ... }:
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
  home.activation.linkMiseConfig = pkgs.lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/mise
    rm -f $HOME/.config/mise/config.toml
    ln -sf $HOME/Repos/dot-files/conf.d/mise/config.toml $HOME/.config/mise/config.toml
  '';

  home.file.".config/nvim.session" = {
    text = ''
      ${builtins.readFile ./conf.d/terminal/nvim.session}
    '';
  };

  home.file.".config/kitty/kitty.conf" = {
    source = ./conf.d/terminal/kitty.conf;
  };

}
