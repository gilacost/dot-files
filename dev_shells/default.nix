# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/erlang/otp/archive/refs/tags/OTP-${VERSION}.zip
# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/elixir-lang/elixir/archive/refs/tags/v${VERSION}.zip

{ flake-utils, nixpkgs, expert, ... }:
let
  mkElixirErlangShell = import ./elixir_erlang.nix;
  mkTerraformShell = import ./terraform.nix;
  mkOpenTofuShell = import ./opentofu.nix;
  mkRedisShell = import ./redis.nix;
  mkMiseShell = import ./mise.nix;
  mkAsdfShell = import ./asdf.nix;
in
flake-utils.lib.eachDefaultSystemMap (system: {

  opentofu_1_9_0 = mkOpenTofuShell {
    inherit system nixpkgs;
    tofuVersion = "1.9.0";
    tofuSha256 = "sha256-c2vGE4+FAzG0Z8gUu7uPowflKR3I2kKmb7zqjqdo0x4=";
  };

  terraform_1_13_5 = mkTerraformShell {
    inherit system nixpkgs;
    terraformVersion = "1.13.5";
    terraformSha256 = "1jv2vdnmqhja1jgx31vz92n2dxal1s17nvccqfjf3rrm28il5y8v";

    sopsVersion = "3.11.0";
    sopsSha256 = "sha256-ylVg3kap6Dw4afu9vI5jn8Wfhik5lBJ+GAye5vzSgfY=";

    ageVersion = "1.2.1";
    ageSha256 = "sha256-z3mHW9WXDcLaxgyH+lDO4f8fmkGw6yc/ZeF0r/N8Nno=";

    terraformLsVersion = "0.38.2";
    terraformLsSha256 = "0yralczjcgg6lryypj9wqxr83j5djmmnrcy4yj5a6z6yr1fx39xi";
  };

  terraform_1_13_3 = mkTerraformShell {
    inherit system nixpkgs;
    terraformVersion = "1.13.3";
    terraformSha256 = "sha256-g2LnKEs4oRlIhJY97tg0gWltRotC2riAUndfQoA4NYQ=";

    sopsVersion = "3.10.2";
    sopsSha256 = "10hxym70a6xwvsc1sm904kvfp7cqx4v1wh57cm95jq0775vp5af2";

    ageVersion = "1.2.1";
    ageSha256 = "sha256-z3mHW9WXDcLaxgyH+lDO4f8fmkGw6yc/ZeF0r/N8Nno=";

    terraformLsVersion = "0.37.0";
    terraformLsSha256 = "sha256-ax3Vd3BgD9K5+/WrI5fcksrG2f4SedRV8uQws0o06Yk=";
  };

  terraform_1_12_0 = mkTerraformShell {
    inherit system nixpkgs;
    terraformVersion = "1.12.0";
    terraformSha256 = "sha256-TmyrkCvUPSGLo+kho9gNTJ5QVtnVutuscZB0GvwJVQY=";

    sopsVersion = "3.10.2";
    sopsSha256 = "sha256-wqlydzkHYFlSZadAHjbpmJ3r9iQgVR2Y3rwbBU71HYI=";

    ageVersion = "1.2.1";
    ageSha256 = "sha256-z3mHW9WXDcLaxgyH+lDO4f8fmkGw6yc/ZeF0r/N8Nno=";

    terraformLsVersion = "0.36.4";
    terraformLsSha256 = "sha256-55AkxwTEj6POUKVBFTwtJrnosKhRpvGNwcgc1X1BlTI=";
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

  elixir_1_19_2_erlang_28_1_1 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs expert;
    elixirVersion = "1.19.2";
    elixirSha256 = "0556xjkh5229afl22av2g8gkq5ak0gfipm90ybgnq2d2brd714xh";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "28.1.1";
    erlangSha256 = "09774q6j15gyka2497cj1yzzj5l2a4qb4ifkwcwxdpbi7bvjk2nr";
    erlangInterpreter = "erlang_28";
    lexicalVersion = "v0.7.3";
    lexicalSha256 = "18rjx74vx73rgqpvj6xm2wp7pb7ca6rhzzry50jx045zkclg7bhp";
  };

  elixir_1_18_4_erlang_28_0_2 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs expert;
    elixirVersion = "1.18.4";
    elixirSha256 = "0861h06x1594jsqq21lkmd96yvlfhfngrrxm6fwpqifzw4ij02iz";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "28.0.2";
    erlangSha256 = "0hqljgbhw7yx9hbpd2k0sdvr1psp4aq56wn3d8qa1q0pqpn6zqp3";
    erlangInterpreter = "erlang_28";
    lexicalVersion = "v0.7.3";
    lexicalSha256 = "18rjx74vx73rgqpvj6xm2wp7pb7ca6rhzzry50jx045zkclg7bhp";
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
    lexicalVersion = "v0.7.3";
    lexicalSha256 = "sha256-p8XSJBX1igwC+ssEJGD8wb/ZYaEgLGozlY8N6spo3cA=";
  };

  elixir_1_16_3_erlang_25_3_2_20 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.16.3";
    elixirSha256 = "0db1f6p8409ld81lfd9ln9ir4v55h48lzsbd91jz0hns7ninlh2r";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "25.3.2.20";
    erlangSha256 = "0xz61gasvzlpbws56jbh4lgpa8zanf9dbhwzxkgyscbh6ph6zspg";
    erlangInterpreter = "erlang_26";
    lexicalVersion = "v0.7.3";
    lexicalSha256 = "sha256-p8XSJBX1igwC+ssEJGD8wb/ZYaEgLGozlY8N6spo3cA=";
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
    elixirLsVersion = "v0.27.2";
    elixirLsSha256 = "sha256-y1QT+wRFc+++OVFJwEheqcDIwaKHlyjbhEjhLJ2rYaI=";
  };

  elixir_1_17_2_erlang_26_2_5 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.17.2";
    elixirSha256 = "063pfz6ljy22b4nyvk8pi8ggqb6nmzqcca08vnl3h9xgh1zzddpj";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.2.5";
    erlangSha256 = "sha256-tUAvzkTE51gT4kS7voEZZpsMKVyBQR+wgk6mI0s1Vac=";
    erlangInterpreter = "erlang_26";
    elixirLsVersion = "v0.27.2";
    elixirLsSha256 = "sha256-y1QT+wRFc+++OVFJwEheqcDIwaKHlyjbhEjhLJ2rYaI=";
  };

  elixir_1_17_2_erlang_26_0 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.17.2";
    elixirSha256 = "063pfz6ljy22b4nyvk8pi8ggqb6nmzqcca08vnl3h9xgh1zzddpj";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.0";
    erlangSha256 = "sha256-7z5LkCLyjqGlo48XlcwAUiu1FkmAAewEGnP30QDDme8=";
    erlangInterpreter = "erlang_26";
    elixirLsVersion = "v0.27.2";
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

  mise_2024_12_5 = mkMiseShell {
    inherit system nixpkgs;
    miseVersion = "2024.12.5";
    miseSha256 = "sha256-dODngIwyrpLEB57c4348N4Ik+lNYEjS0kOw7Ug92QA8=";
  };

  asdf_0_14_0 = mkAsdfShell {
    inherit system nixpkgs;
    asdfVersion = "0.14.0";
    asdfSha256 = "0s1jm8rkv9f5xhjhfy0a8fn2x24az3249xhq6cj3l7i8dp6hlv0f";
  };

  # elixir_chromic_pdf =
  # import ./elixir_chromic_pdf.nix { inherit system nixpkgs; };

  # elixir_wallaby = import ./elixir_wallaby.nix { inherit system nixpkgs; };

  # node = import ./node.nix { inherit system nixpkgs; };
})
