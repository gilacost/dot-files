{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "mcp-hub";
  version = "main";

  src = pkgs.fetchFromGitHub {
    owner = "ravitemer";
    repo = "mcp-hub";
    rev = "6e2f2611390dc3e6eb53e328826529f5c598b048";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # placeholder
  };

  nativeBuildInputs = [ pkgs.nodejs ];

  installPhase = ''
    mkdir -p $out/bin
    npm install -g . --prefix=$out
  '';
}
