{ system, nixpkgs, tofuVersion, tofuSha256 }:
let
  inherit (nixpkgs.lib) optionalString;

  # Map system to platform triple used by OpenTofu
  platform =
    if system == "x86_64-linux" then "linux_amd64"
    else if system == "aarch64-linux" then "linux_arm64"
    else if system == "x86_64-darwin" then "darwin_amd64"
    else if system == "aarch64-darwin" then "darwin_arm64"
    else throw "Unsupported system: ${system}";

  # Build the URL dynamically
  tofuUrl =
    "https://github.com/opentofu/opentofu/releases/download/v${tofuVersion}/tofu_${tofuVersion}_${platform}.zip";

  pkgs = import nixpkgs {
    inherit system;
  };

  opentofu = pkgs.stdenv.mkDerivation {
    pname = "opentofu";
    version = tofuVersion;

    src = pkgs.fetchurl {
      url = tofuUrl;
      sha256 = tofuSha256;
    };

    nativeBuildInputs = [ pkgs.unzip ];
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
    '';
  };

in pkgs.mkShell {
  buildInputs = [
    opentofu
    pkgs.tflint
    pkgs.terraform-docs
    pkgs.tfsec
  ];

  shellHook = ''
    echo "🌱 OpenTofu $(${opentofu}/bin/tofu version | head -n 1)"
    echo "🧹 TFLint $(${pkgs.tflint}/bin/tflint --version)"
    echo "📄 Terraform-docs $(${pkgs.terraform-docs}/bin/terraform-docs --version)"
    echo "🔐 tfsec $(${pkgs.tfsec}/bin/tfsec --version)"
  '';
}
