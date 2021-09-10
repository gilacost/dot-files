{
  description = "Pepo’s Nix system configs, and some other useful stuff.";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
  };


  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs:
    let
      # Some building blocks --------------------------------------------------------------------- {{{

      # Configuration for `nixpkgs` mostly used in personal configs.
      nixpkgsConfig = with inputs; rec {
        config = { allowUnfree = true; };
        overlays = self.overlays ++ [
          (
            final: prev: {
              master = import nixpkgs-master { inherit (prev) system; inherit config; };
              unstable = import nixpkgs-unstable { inherit (prev) system; inherit config; };

              # Packages I want on the bleeding edge
              # kitty = final.unstable.kitty;
              # neovim = final.unstable.neovim;
              # neovim-unwrapped = final.unstable.neovim-unwrapped;
              # nixUnstable = final.unstable.nixUnstable;
              # vimPlugins = prev.vimPlugins // final.unstable.vimPlugins;
            }
          )
        ];
      };

      # Personal configuration shared between `nix-darwin` and plain `home-manager` configs.
      homeManagerCommonConfig = with self.homeManagerModules; {
        imports = [
          ./home.nix
        ];
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = [
        # Include extra `nix-darwin`
        self.darwinModules.programs.nix-index
        self.darwinModules.security.pam
        self.darwinModules.users
        # Main `nix-darwin` config
        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { config, lib, ... }: let
            inherit (config.users) primaryUser;
          in
            {
              nixpkgs = nixpkgsConfig;
              # Hack to support legacy worklows that use `<nixpkgs>` etc.
              nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
              # `home-manager` config
              users.users.${primaryUser}.home = "/Users/${primaryUser}";
              home-manager.useGlobalPkgs = true;
              home-manager.users.${primaryUser} = homeManagerCommonConfig;
            }
        )
      ];
      # }}}
    in
      {

        # Personal configuration ------------------------------------------------------------------- {{{

        # My `nix-darwin` configs
        darwinConfigurations = {
          # Mininal configuration to bootstrap systems
          bootstrap = darwin.lib.darwinSystem {
            modules = [ ./darwin-configuration.nix { nixpkgs = nixpkgsConfig; } ];
          };

          # My macOS main laptop config
          PeposBookPro = darwin.lib.darwinSystem {
            modules = nixDarwinCommonModules ++ [
              {
                users.primaryUser = "pepo";
                networking.computerName = "Pepo's";
                networking.hostName = "PeposBookPro";
              }
            ];
          };
        };

        # Add re-export `nixpkgs` packages with overlays.
        # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
      } // flake-utils.lib.eachDefaultSystem (
        system: {
          legacyPackages = import nixpkgs { inherit system; inherit (nixpkgsConfig) config; };
        }
      );
}
