# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/erlang/otp/archive/refs/tags/OTP-${VERSION}.zip
# NOTE: nix-prefetch-url --type sha256 --unpack https://github.com/elixir-lang/elixir/archive/refs/tags/v${VERSION}.zip

{ flake-utils, nixpkgs, ... }:
let mkElixirErlangShell = import ./elixir_erlang.nix;
in flake-utils.lib.eachDefaultSystemMap (system: {
  elixir_1_14_2_erlang_25_1 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.14.2";
    elixirSha256 = "1w0wda304bk3j220n76bmv4yv0pkl9jca8myipvz7lm6fnsvw500";
    erlangVersion = "25.2";
    erlangSha256 = "138xyqaa114fgv3gk01rawz9asg86maffj8yrhikgd8zsb8a57nd";
  };

  elixir_1_13_4_erlang_24_3_4 = mkElixirErlangShell {
    inherit system;
    inherit nixpkgs;
    elixirVersion = "1.13.4";
    elixirSha256 = "1z19hwnv7czmg3p56hdk935gqxig3x7z78yxckh8fs1kdkmslqn4";
    erlangVersion = "24.3.4";
    erlangSha256 = "1hb5rr952lgglwz721hkczjrag29ri1w9q3va6whcx3dwsyw39i2";
  };

  elixir_chromic_pdf =
    import ./elixir_chromic_pdf.nix { inherit system nixpkgs; };

  elixir_wallaby = import ./elixir_wallaby.nix { inherit system nixpkgs; };

  node = import ./node.nix { inherit system nixpkgs; };
})
