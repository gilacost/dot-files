# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/erlang/otp/archive/refs/tags/OTP-${VERSION}.zip
# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/elixir-lang/elixir/archive/refs/tags/v${VERSION}.zip

{ flake-utils, nixpkgs, ... }:
let
  mkElixirErlangShell = import ./elixir_erlang.nix;
  mkTerraformShell = import ./terraform.nix;
  mkOpenTofuShell = import ./opentofu.nix;
in
flake-utils.lib.eachDefaultSystemMap (system: {

  opentofu_1_9_0 = mkOpenTofuShell {
    inherit system nixpkgs;
    tofuVersion = "1.9.0";
    tofuSha256 = "sha256-c2vGE4+FAzG0Z8gUu7uPowflKR3I2kKmb7zqjqdo0x4=";
  };

  terraform_1_11_3 = mkTerraformShell {
    inherit system nixpkgs;
    terraformVersion = "1.11.3";
    terraformSha256 = "sha256-wMZPp7hZ9QX9zv2riTF+mLJo9o1AHah98LACHoJ88Zc=";
  };

  terraform_1_7_5 = mkTerraformShell {
    inherit system nixpkgs;
    terraformVersion = "1.7.5";
    terraformSha256 = "sha256-mcTU/q+wGDry9/vge+7qb4Pl9aKa4p/uMWi2gQ43/5g=";
  };

  elixir_1_18_1_erlang_27_2 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.18.1";
    elixirSha256 = "1bzg3m4dbhvrxv7f20q77j3648j0fkpnmajh4yfz53wj5ail14yc";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "27.2";
    erlangSha256 = "00zk0cziyylmzg63gq3h5p2p348ahg2wp5h8zhbva4h3v5w6fi7j";
    erlangInterpreter = "erlang_27";
    elixirLsVersion = "2257b6b100e200f3ce1a8d08e37d1fd224ecdeb1";
    elixirLsSha256 = "sha256-y1QT+wRFc+++OVFJwEheqcDIwaKHlyjbhEjhLJ2rYaI=";
  };

  elixir_1_17_2_erlang_26_2_5 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.17.2";
    elixirSha256 = "063pfz6ljy22b4nyvk8pi8ggqb6nmzqcca08vnl3h9xgh1zzddpj";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.2.5.2";
    erlangSha256 = "sha256-Co1rLqrdjq+aIiSEX0+59Cd5lOYkMdxsXgr3r7wt3Pc=";
    erlangInterpreter = "erlang_26";
  };

  elixir_1_15_6_erlang_26_1_1 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.15.6";
    elixirSha256 = "eRwyqylldsJOsGAwm61m7jX1yrVDrTPS0qO23lJkcKc=";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.1.1";
    erlangSha256 = "Y0sArUFkGxlAAgrgUxn5Rjnd72geG08VO9FBxg/fJAg=";
    erlangInterpreter = "erlang_26";
  };

  elixir_1_15_4_erlang_26_0_2 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.15.4";
    elixirSha256 = "sha256-0DrfKQPyFX+zurCIZ6RVj9vm1lHSkJSfhiUaRpa3FFo=";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.0.2";
    erlangSha256 = "sha256-GzF/cpTUe5hoocDK5aio/lo8oYFeTr+HkftTYpQnOdA=";
    erlangInterpreter = "erlang_26";
  };

  elixir_1_14_3_erlang_25_2_2 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.14.3";
    elixirSha256 = "0kkq1nk75snnk5z75ypcfcg2if611yi33lkr2n5dcr800k42xfgj";
    erlangVersion = "25.2.2";
    erlangSha256 = "0jwwvs6fq7rljnk9sy22ycd98y86dvgjnb0fh6zmfz32i3c23w8x";
    erlangInterpreter = "erlang_25";
  };

  # elixir_chromic_pdf =
  # import ./elixir_chromic_pdf.nix { inherit system nixpkgs; };

  # elixir_wallaby = import ./elixir_wallaby.nix { inherit system nixpkgs; };

  # node = import ./node.nix { inherit system nixpkgs; };
})
