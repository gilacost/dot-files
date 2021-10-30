{
  description = "Pep's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";

    nur.url = "github:nix-community/NUR";

  };

  outputs = { self, darwin, nixpkgs, home-manager, nur, ... }:
    let
      common = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          nixpkgs.overlays = [ nur.overlay ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pepo = import ./home.nix;
        }
      ];
    in {

      darwinConfigurations = {
        "lair" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = common;
        };
        "cienaga" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = common;
        };
      };
    };
}
