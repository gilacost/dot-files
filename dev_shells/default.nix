# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/erlang/otp/archive/refs/tags/OTP-${VERSION}.zip
# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/elixir-lang/elixir/archive/refs/tags/v${VERSION}.zip

{ flake-utils, nixpkgs, ... }:
let mkElixirErlangShell = import ./elixir_erlang.nix;
in
flake-utils.lib.eachDefaultSystemMap (system: {
  elixir_1_17_2_erlang_27_0_1 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.17.2";
    elixirSha256 = "063pfz6ljy22b4nyvk8pi8ggqb6nmzqcca08vnl3h9xgh1zzddpj";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "27.0.1";
    erlangSha256 = "0m3l2d5vpd7wlw7grzdvz63vi1h8px9pjqqls7i70idsxbsqk7if";
    erlangInterpreter = "erlang_27";
  };

  elixir_1_17_2_erlang_26_2_5 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.17.2";
    elixirSha256 = "063pfz6ljy22b4nyvk8pi8ggqb6nmzqcca08vnl3h9xgh1zzddpj";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.2.5.2";
    erlangSha256 = "sha256-Co1rLqrdjq+aIiSEX0+59Cd5lOYkMdxsXgr3r7wt3Pc=";
    erlangInterpreter = "erlangR26";
  };

  elixir_1_15_6_erlang_26_1_1 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.15.6";
    elixirSha256 = "eRwyqylldsJOsGAwm61m7jX1yrVDrTPS0qO23lJkcKc=";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.1.1";
    erlangSha256 = "Y0sArUFkGxlAAgrgUxn5Rjnd72geG08VO9FBxg/fJAg=";
    erlangInterpreter = "erlangR26";
  };

  elixir_1_15_4_erlang_26_0_2 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.15.4";
    elixirSha256 = "sha256-0DrfKQPyFX+zurCIZ6RVj9vm1lHSkJSfhiUaRpa3FFo=";
    elixirEscriptPath = "lib/elixir/scripts/generate_app.escript";
    erlangVersion = "26.0.2";
    erlangSha256 = "sha256-GzF/cpTUe5hoocDK5aio/lo8oYFeTr+HkftTYpQnOdA=";
    erlangInterpreter = "erlangR26";
  };

  elixir_1_14_3_erlang_25_2_2 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.14.3";
    elixirSha256 = "0kkq1nk75snnk5z75ypcfcg2if611yi33lkr2n5dcr800k42xfgj";
    erlangVersion = "25.2.2";
    erlangSha256 = "0jwwvs6fq7rljnk9sy22ycd98y86dvgjnb0fh6zmfz32i3c23w8x";
    erlangInterpreter = "erlangR25";
  };

  elixir_1_14_2_erlang_25_1 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.14.2";
    elixirSha256 = "1w0wda304bk3j220n76bmv4yv0pkl9jca8myipvz7lm6fnsvw500";
    erlangVersion = "25.2";
    erlangSha256 = "138xyqaa114fgv3gk01rawz9asg86maffj8yrhikgd8zsb8a57nd";
    erlangInterpreter = "erlangR25";
  };

  elixir_1_13_4_erlang_24_3_4 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.13.4";
    elixirSha256 = "1z19hwnv7czmg3p56hdk935gqxig3x7z78yxckh8fs1kdkmslqn4";
    erlangVersion = "24.3.4";
    erlangSha256 = "1hb5rr952lgglwz721hkczjrag29ri1w9q3va6whcx3dwsyw39i2";
    erlangInterpreter = "erlangR24";
  };

  elixir_chromic_pdf =
    import ./elixir_chromic_pdf.nix { inherit system nixpkgs; };

  elixir_wallaby = import ./elixir_wallaby.nix { inherit system nixpkgs; };

  node = import ./node.nix { inherit system nixpkgs; };
})
