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
    ./modules/claude
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

  home.file.".config/mise/config.toml" = {
    source = ./conf.d/mise/config.toml;
  };

  home.file.".config/nvim.session" = {
    text = ''
      ${builtins.readFile ./conf.d/terminal/nvim.session}
    '';
  };

  home.file.".config/kitty/kitty.conf" = {
    source = ./conf.d/terminal/kitty.conf;
  };

}
