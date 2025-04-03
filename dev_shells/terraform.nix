{ system, nixpkgs, terraformVersion, terraformSha256 }:
let
  inherit (nixpkgs.lib) optionalString;

  # Map system to platform triple used by HashiCorp
  platform =
    if system == "x86_64-linux" then "linux_amd64"
    else if system == "aarch64-linux" then "linux_arm64"
    else if system == "x86_64-darwin" then "darwin_amd64"
    else if system == "aarch64-darwin" then "darwin_arm64"
    else throw "Unsupported system: ${system}";

  # Build the URL dynamically
  terraformUrl =
    "https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_${platform}.zip";

  pkgs = import nixpkgs {
    inherit system;
    # Not needed unless using nixpkgs-provided terraform
    # config.allowUnfree = true;
  };

  terraform = pkgs.stdenv.mkDerivation {
    pname = "terraform";
    version = terraformVersion;

    src = pkgs.fetchurl {
      url = terraformUrl;
      sha256 = terraformSha256;
    };

    nativeBuildInputs = [ pkgs.unzip ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
    '';
  };
in
pkgs.mkShell {
  buildInputs = [
    terraform
    pkgs.tflint
    pkgs.terraform-docs
    pkgs.tfsec
  ];

  shellHook = ''
    echo "🌍 Terraform $(${terraform}/bin/terraform version | head -n 1)"
    echo "🧹 TFLint $(${pkgs.tflint}/bin/tflint --version)"
    echo "📄 Terraform-docs $(${pkgs.terraform-docs}/bin/terraform-docs --version)"
    echo "🔐 tfsec $(${pkgs.tfsec}/bin/tfsec --version)"
  '';
}
