{
  description = "Pep's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";

    nur.url = "github:nix-community/NUR";

  };

  outputs = { self, darwin, nixpkgs, home-manager, nur, ... }@inputs:
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
      devShells = import ./dev_shells inputs;
      darwinConfigurations = {

        "lair" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = common
            ++ [ ({ pkgs, config, ... }: { networking.hostName = "lair"; }) ];
        };

        "cave" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = common
            ++ [ ({ pkgs, config, ... }: { networking.hostName = "cave"; }) ];
        };
      };
    };
}
