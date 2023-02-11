# NOTE: Based on github.com/the-nix-way/dev-templates

inputs:
let
  overlays = [ (self: super: rec { dotnet = super.dotnet-sdk_7; }) ];
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system overlays; };
in pkgs.mkShell {
  buildInputs = with pkgs; [ dotnet ];

  shellHook = ''
    echo "🤓 Dotnet `${pkgs.dotnet}/bin/dotnet --version`"
  '';
}
