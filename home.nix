{ config, pkgs, lib, devenv, ... }: {


  # programs.nix.package = pkgs.nixVersions.latest;
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  imports = [
    ./modules/gh
    ./modules/git
    ./modules/zsh
    ./modules/tools
    ./modules/editor
  ];

  # home.file.".ssh/config" = {
  # text = ''
  # Host *
  # IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  # '';
  # };

  home.file.".config/peco/config.json" = {
    text = ''
      {
         "Style": {
             "Basic": ["on_default", "default"],
             "SavedSelection": ["bold", "on_yellow", "black"],
             "Selected": ["underline", "on_cyan", "black"],
             "Query": ["yellow", "bold"],
             "Matched": ["red", "on_blue"]
         },
         "Use256Color": true
      }
    '';
  };

}
