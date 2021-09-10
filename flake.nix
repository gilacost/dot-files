{
  description = "Pepo's darwin system";

  inputs = {
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, darwin, nixpkgs, home-manager }: {
    darwinConfigurations."homebook" = darwin.lib.darwinSystem {

      modules = [
        ./darwin-configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pepo = import ./home.nix;
        }

      ];
    };
    darwinPackages = self.darwinConfigurations."homebook".pkgs;
  };
}
