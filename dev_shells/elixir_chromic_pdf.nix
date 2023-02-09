inputs:
let
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system; };
in pkgs.mkShell {
  buildInputs = with pkgs; [ chromium ghostscript ];

  shellHook = ''
    echo "🕸️ $(${pkgs.chromium}/bin/chromium --version)"
    echo "👻 GhostScript $(${pkgs.ghostscript}/bin/gs --version)"
  '';
}
