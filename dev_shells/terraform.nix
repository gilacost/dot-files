{
  system,
  nixpkgs,
  terraformVersion,
  terraformSha256,
  sopsVersion,
  sopsSha256,
  ageVersion,
  ageSha256,
  terraformLsVersion,
  terraformLsSha256,
}:
let
  inherit (nixpkgs.lib) optionalString;

  platform =
    if system == "x86_64-linux" then
      "linux_amd64"
    else if system == "aarch64-linux" then
      "linux_arm64"
    else if system == "x86_64-darwin" then
      "darwin_amd64"
    else if system == "aarch64-darwin" then
      "darwin_arm64"
    else
      throw "Unsupported system: ${system}";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  terraform = pkgs.stdenv.mkDerivation {
    pname = "terraform";
    version = terraformVersion;

    src = pkgs.fetchurl {
      url = "https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_${platform}.zip";
      sha256 = terraformSha256;
    };

    nativeBuildInputs = [ pkgs.unzip ];
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
    '';
  };

  sopsPlatform =
    if system == "x86_64-linux" then
      "linux"
    else if system == "aarch64-linux" then
      "linux"
    else if system == "x86_64-darwin" || system == "aarch64-darwin" then
      "darwin"
    else
      throw "Unsupported system: ${system}";

  sops = pkgs.stdenv.mkDerivation {
    pname = "sops";
    version = sopsVersion;

    src = pkgs.fetchurl {
      url = "https://github.com/mozilla/sops/releases/download/v${sopsVersion}/sops-v${sopsVersion}.${sopsPlatform}";
      sha256 = sopsSha256;
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/sops
      chmod +x $out/bin/sops
    '';
  };

  agePlatform =
    if system == "x86_64-linux" then
      "linux-amd64"
    else if system == "aarch64-linux" then
      "linux-arm64"
    else if system == "x86_64-darwin" then
      "darwin-amd64"
    else if system == "aarch64-darwin" then
      "darwin-arm64"
    else
      throw "Unsupported system: ${system}";

  age = pkgs.stdenv.mkDerivation {
    pname = "age";
    version = ageVersion;

    src = pkgs.fetchurl {
      url = "https://github.com/FiloSottile/age/releases/download/v${ageVersion}/age-v${ageVersion}-${agePlatform}.tar.gz";
      sha256 = ageSha256;
    };

    nativeBuildInputs = [
      pkgs.gnutar
      pkgs.gzip
    ];
    unpackPhase = "tar -xzf $src";

    installPhase = ''
      mkdir -p $out/bin
      cp age/age $out/bin/
      cp age/age-keygen $out/bin/
      chmod +x $out/bin/age $out/bin/age-keygen
    '';
  };
  terraformLsPlatform =
    if system == "x86_64-linux" then
      "linux_amd64"
    else if system == "aarch64-linux" then
      "linux_arm64"
    else if system == "x86_64-darwin" then
      "darwin_amd64"
    else if system == "aarch64-darwin" then
      "darwin_arm64"
    else
      throw "Unsupported system: ${system}";

  terraformLs = pkgs.stdenv.mkDerivation {
    pname = "terraform-ls";
    version = terraformLsVersion;

    src = pkgs.fetchurl {
      url = "https://releases.hashicorp.com/terraform-ls/${terraformLsVersion}/terraform-ls_${terraformLsVersion}_${terraformLsPlatform}.zip";
      sha256 = terraformLsSha256;
    };

    nativeBuildInputs = [ pkgs.unzip ];
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
      chmod +x $out/bin/terraform-ls
    '';
  };

in
pkgs.mkShell {
  buildInputs = [
    terraform
    pkgs.tflint
    pkgs.terraform-docs
    pkgs.tfsec
    terraformLs
    sops
    age
  ];

  shellHook = ''
    echo "🌍 Terraform $(${terraform}/bin/terraform version | head -n 1)"
    echo "🧹 TFLint $(${pkgs.tflint}/bin/tflint --version)"
    echo "📄 Terraform-docs $(${pkgs.terraform-docs}/bin/terraform-docs --version)"
    echo "🧠 Terraform LS $(${terraformLs}/bin/terraform-ls version)"
    echo "🔐 tfsec $(${pkgs.tfsec}/bin/tfsec --version)"
    echo "🔐 SOPS $(${sops}/bin/sops --version)"
    echo "🔑 age $(${age}/bin/age --version)"
    export TERRAFORM_LS_PATH="${terraformLs}/bin/terraform-ls"

    echo "🧠 Terraform LS version: $(${terraformLs}/bin/terraform-ls --version)"

    # Remove old symlink
    rm -rf "$HOME/.terraform-ls"

    # Link the correct terraform-ls binary
    ln -sf "${terraformLs}/" "$HOME/.terraform-ls"
    echo "🔗 Symlinked Terraform LS to: $HOME/.terraform-ls"
  '';
}
