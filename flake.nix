{
  description = "John's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    # nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, darwin, nixpkgs }: {
    darwinConfigurations."Joseps-MBP" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ ./darwin-configuration.nix ];
    };
  };
}
# {
#   description = "nix system configurations";

#   inputs = {
#     darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
#     devshell.url = "github:numtide/devshell";
#     flake-utils.url = "github:numtide/flake-utils";
#     # nixos-hardware.url = "github:nixos/nixos-hardware";
#     nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
#     # comma = {
#     #   url = "github:Shopify/comma";
#     #   flake = false;
#     # };
#     flake-compat = {
#       url = "github:edolstra/flake-compat";
#       flake = false;
#     };
#     darwin = {
#       url = "github:kclejeune/nix-darwin/backup-etc";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#     home-manager = {
#       url = "github:nix-community/home-manager/master";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#   };

#   outputs = inputs@{ self, nixpkgs, darwin, home-manager, nixos-hardware
#     , devshell, flake-utils, ... }:
#     let
#       inherit (darwin.lib) darwinSystem;
#       inherit (nixpkgs.lib) nixosSystem;
#       inherit (home-manager.lib) homeManagerConfiguration;
#       inherit (flake-utils.lib) eachDefaultSystem eachSystem;
#       inherit (builtins) listToAttrs map;

#       mkLib = nixpkgs:
#         nixpkgs.lib.extend
#         (final: prev: (import ./lib final) // home-manager.lib);

#       lib = (mkLib nixpkgs);

#       isDarwin = system: (builtins.elem system lib.platforms.darwin);
#       homePrefix = system: if isDarwin system then "/Users" else "/home";

#       # generate a base darwin configuration with the
#       # specified hostname, overlays, and any extraModules applied
#       mkDarwinConfig = { system ? "x86_64-darwin", nixpkgs ? inputs.nixpkgs
#         , stable ? inputs.darwin-stable, lib ? (mkLib nixpkgs), baseModules ? [
#           home-manager.darwinModules.home-manager
#           ./modules/darwin
#         ], extraModules ? [ ] }:
#         darwinSystem {
#           inherit system;
#           modules = baseModules ++ extraModules;
#           specialArgs = { inherit inputs lib nixpkgs stable; };
#         };

#     in {
#       checks = listToAttrs (
#         # darwin checks
#         (map (system: {
#           name = system;
#           value = {
#             darwin =
#               self.darwinConfigurations.randall-intel.config.system.build.toplevel;
#             darwinServer =
#               self.homeConfigurations.darwinServer.activationPackage;
#           };
#         }) lib.platforms.darwin) ++
#         # linux checks
#         (map (system: {
#           name = system;
#           value = {
#             nixos = self.nixosConfigurations.phil.config.system.build.toplevel;
#             server = self.homeConfigurations.server.activationPackage;
#           };
#         }) lib.platforms.linux));

#       darwinConfigurations = {
#         randall = mkDarwinConfig {
#           system = "aarch64-darwin";
#           extraModules = [
#             ./profiles/personal.nix
#             ./modules/darwin/apps.nix
#             { homebrew.brewPrefix = "/opt/homebrew/bin"; }
#           ];
#         };
#         randall-intel = mkDarwinConfig {
#           system = "x86_64-darwin";
#           extraModules = [
#             ./profiles/personal.nix
#             ./modules/darwin/apps.nix
#             { homebrew.brewPrefix = "/opt/homebrew/bin"; }
#           ];
#         };
#         work = mkDarwinConfig {
#           extraModules =
#             [ ./profiles/work.nix ./modules/darwin/apps-minimal.nix ];
#         };
#       };

#       nixosConfigurations = {
#         phil = mkNixosConfig {
#           hardwareModules = [
#             ./modules/hardware/phil.nix
#             nixos-hardware.nixosModules.lenovo-thinkpad-t460s
#           ];
#           extraModules = [ ./profiles/personal.nix ];
#         };
#       };

#       homeConfigurations = {
#         server = mkHomeConfig {
#           username = "kclejeune";
#           extraModules = [ ./profiles/home-manager/personal.nix ];
#         };
#         darwinServer = mkHomeConfig {
#           username = "kclejeune";
#           system = "x86_64-darwin";
#           extraModules = [ ./profiles/home-manager/personal.nix ];
#         };
#         workServer = mkHomeConfig {
#           username = "lejeukc1";
#           extraModules = [ ./profiles/home-manager/work.nix ];
#         };
#         vagrant = mkHomeConfig {
#           username = "vagrant";
#           extraModules = [ ./profiles/home-manager/personal.nix ];
#         };
#       };
#     } //
#     # add a devShell to this flake
#     eachDefaultSystem (system:
#       let
#         pkgs = import nixpkgs {
#           inherit system;
#           overlays = [
#             devshell.overlay
#             (final: prev: {
#               # expose stable packages via pkgs.stable
#               stable = import inputs.nixos-stable { system = prev.system; };
#             })
#           ];
#         };
#         pyEnv = (pkgs.stable.python3.withPackages
#           (ps: with ps; [ black pylint typer colorama shellingham ]));
#         nixBin = pkgs.writeShellScriptBin "nix" ''
#           ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
#         '';
#         sysdo = pkgs.writeShellScriptBin "sysdo" ''
#           cd $PRJ_ROOT && ${pyEnv}/bin/python3 bin/do.py $@
#         '';
#       in {
#         devShell = pkgs.devshell.mkShell {
#           packages = [ nixBin pyEnv pkgs.treefmt pkgs.nixfmt pkgs.stylua ];
#           commands = [{
#             name = "sysdo";
#             package = sysdo;
#             category = "utilities";
#             help = "perform actions on this repository";
#           }];
#         };
#       });
# }
