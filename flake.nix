{
  description = "Pep's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    devenv.url = "github:cachix/devenv/latest";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = [
      "nixpkgs-terraform.cachix.org-1:8Sit092rIdAVENA3ZVeH9hzSiqI/jng6JiCrQ1Dmusw="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "pepo.cachix.org-1:8sELuSHMV0vqHtuvnzKh3DCzb/+u+PtCY4Gl6V2blCg="
    ];
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://nixpkgs-terraform.cachix.org"
      "https://pepo.cachix.org"
    ];
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    {
      # devShells = import ./dev_shells inputs;
      darwinConfigurations = {

        "buque" =
          let
            system = "aarch64-darwin";
            devenv = inputs.devenv.packages.${system}.devenv;
            hostname = "buque";
            common = [
              home-manager.darwinModules.home-manager
              {
                nixpkgs.overlays = [ nur.overlay ];
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.pepo = import ./home.nix;
                home-manager.extraSpecialArgs = {
                  inherit devenv;
                };
              }
            ];
          in
          darwin.lib.darwinSystem rec {
            inherit system;
            modules =
              common
              ++ [ ./darwin-configuration.nix ]
              ++ [
                (
                  { pkgs, config, ... }:
                  {
                    networking.hostName = "buque";
                  }
                )
              ];
          };

        # Building the flakes require root privileges to update the HOSTNAME
        # and then be able to nix build ".#HOSTNAME"
        # TODO build the flake also for nixos
      };
    };
}
