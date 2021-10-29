{
  description = "Home Manager NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: {
    homeConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-darwin";
        modules = [
          ../../configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pepo = import ./home.nix;
          }
        ];
        # configuration = { config, pkgs, ... }:
        #   let
        #     overlay-unstable = final: prev: {
        #       unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-darwin;
        #     };
        #   in {
        #     nixpkgs.overlays = [ overlay-unstable ];
        #     nixpkgs.config = {
        #       allowUnfree = true;
        #       allowBroken = true;
        #     };

      };
    };
    pepo = self.homeConfigurations.pepo.activationPackage;
    defaultPackage.x86_64-darwin = self.pepo;
  };
}
