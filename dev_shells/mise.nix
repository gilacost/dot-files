inputs:
let
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system; };
  
  miseVersion = inputs.miseVersion or "2024.1.35";
  miseSha256 = inputs.miseSha256 or "sha256-PLACEHOLDER";
  
  mise = pkgs.rustPlatform.buildRustPackage rec {
    pname = "mise";
    version = miseVersion;
    
    src = pkgs.fetchFromGitHub {
      owner = "jdx";
      repo = "mise";
      rev = "v${miseVersion}";
      sha256 = miseSha256;
    };
    
    cargoHash = "sha256-aj6zb+5TYlom1tDulCOwjw2CB0L8C9BdYHUVARgZV6c=";
    
    doCheck = false;
    
    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ openssl ];
    # Security framework is provided by stdenv on Darwin
  };
  
in pkgs.mkShell {
  buildInputs = with pkgs; [
    mise
    git
    curl
  ];
  shellHook = ''
    export MISE_DATA_DIR="$PWD/.mise-test"
    echo "mise test environment loaded"
    echo "🔧 mise version: ${miseVersion}"
  '';
}