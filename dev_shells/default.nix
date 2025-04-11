# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/erlang/otp/archive/refs/tags/OTP-${VERSION}.zip
# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/elixir-lang/elixir/archive/refs/tags/v${VERSION}.zip

{ flake-utils, nixpkgs, ... }:
let
  mkElixirErlangShell = import ./elixir_erlang.nix;
  mkTerraformShell = import ./terraform.nix;
  mkOpenTofuShell = import ./opentofu.nix;
  mkRedisShell = import ./redis.nix;
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

  redis_latest = mkRedisShell {
    inherit system nixpkgs;
  };

  elixir_latest_erlang_latest = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.18.3";
    elixirSha256 = "03d2ha0ykrxwfzj1w7wvapc0w3nm1xchl1m9m7r287anh3wbazwc";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "27.3.2";
    erlangSha256 = "0a4d19z3ccs1fa0597bzm803aqq2q6pqkgg4awqdsbp9dmrf89iz";
    erlangInterpreter = "erlang_27";
    elixirLsVersion = "v0.27.2";
    elixirLsSha256 = "sha256-y1QT+wRFc+++OVFJwEheqcDIwaKHlyjbhEjhLJ2rYaI=";
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
    elixirLsVersion = "2257b6b100e200f3ce1a8d08e37d1fd224ecdeb1"; # try 0.15.0 for the blog post
    elixirLsSha256 = "sha256-y1QT+wRFc+++OVFJwEheqcDIwaKHlyjbhEjhLJ2rYaI=";
  };

  redis_7_4_2 = mkRedisShell {
    inherit system nixpkgs;
    redisVersion = "7.4.2";
    redisSha256 = "sha256-Td678JBhy7WJAReG/r2zTyl2fdf4nb5xLSto6Aivah8=";
  };

  redis_7_2_4 = mkRedisShell {
    inherit system nixpkgs;
    redisVersion = "7.2.4";
    redisSha256 = "sha256-jRBMJqFUsp/WfWVotPN1ISISrUHgwsqj1mSA5429O1k=";
  };

  # elixir_chromic_pdf =
  # import ./elixir_chromic_pdf.nix { inherit system nixpkgs; };

  # elixir_wallaby = import ./elixir_wallaby.nix { inherit system nixpkgs; };

  # node = import ./node.nix { inherit system nixpkgs; };
})
