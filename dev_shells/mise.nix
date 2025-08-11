inputs:
let
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system; };
  
  miseVersion = inputs.miseVersion or "2024.1.35";
  miseSha256 = inputs.miseSha256 or "sha256-PLACEHOLDER";
  
  mise = pkgs.stdenv.mkDerivation {
    pname = "mise";
    version = miseVersion;
    
    src = pkgs.fetchFromGitHub {
      owner = "jdx";
      repo = "mise";
      rev = "v${miseVersion}";
      sha256 = miseSha256;
    };
    
    nativeBuildInputs = with pkgs; [ rustPlatform.cargoSetupHook rustc cargo ];
    
    buildPhase = ''
      cargo build --release
    '';
    
    installPhase = ''
      mkdir -p $out/bin
      cp target/release/mise $out/bin/
    '';
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