inputs:
let
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    bash
    chromedriver
    chromium
  ];

  shellHook = ''
    echo "🖥️ $(${pkgs.bash}/bin/bash --version | head -n 1)"
    echo "🌐 $(${pkgs.chromedriver}/bin/chromedriver --version | cut -d " " -f -2)"
    echo "🕸️ $(${pkgs.chromium}/bin/chromium --version)"
  '';
}
