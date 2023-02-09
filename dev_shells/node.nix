# NOTE: Based on github.com/the-nix-way/dev-templates

inputs:
let
  overlays = [
    (self: super: rec {
      nodejs = super.nodejs-18_x;
      pnpm = super.nodePackages.pnpm;
      yarn = (super.yarn.override { inherit nodejs; });
    })
  ];
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system overlays; };
in pkgs.mkShell {
  buildInputs = with pkgs; [ node2nix nodejs pnpm yarn ];

  shellHook = ''
    echo "🟢 Node `${pkgs.nodejs}/bin/node --version`"
    echo "🐈 Yarn `${pkgs.yarn}/bin/yarn --version`"
  '';
}
