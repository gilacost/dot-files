{
  system,
  nixpkgs,
  elixirVersion,
  elixirSha256,
  erlangVersion,
  erlangSha256,
  erlangInterpreter,
  elixirLsVersion ? "0.15.0",
  elixirLsSha256 ? "sha256-g9Fcz60vlPbD4rE0c+Ymbt74z0XBmT2GLfi35BSK9A8=",
}:
let
  overlays = [
    (self: super: rec {
      erlang = super.beam.interpreters.${erlangInterpreter}.override {
        version = erlangVersion;
        sha256 = erlangSha256;
      };

      elixir = (super.beam.packagesWith erlang).elixir.override {
        version = elixirVersion;
        sha256 = elixirSha256;
      };

      elixir-ls = super.stdenv.mkDerivation {
        pname = "elixir-ls";
        version = elixirLsVersion;

        src = super.fetchFromGitHub {
          owner = "elixir-lsp";
          repo = "elixir-ls";
          rev = "v${elixirLsVersion}";
          sha256 = elixirLsSha256;
        };

        nativeBuildInputs = [ self.elixir ];

        buildPhase = ''
          mix deps.get
          mix compile
          mix elixir_ls.release -o elixir-ls-release
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp -r elixir-ls-release/* $out/bin/
        '';
      };
    })
  ];

  pkgs = import nixpkgs {
    inherit system overlays;
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    erlang
    elixir
    elixir-ls
  ];

  shellHook = ''
    echo "💧 Elixir $(${pkgs.elixir}/bin/elixir --version | tail -n 1)"
    echo "🍎 Erlang OTP $(${pkgs.erlang}/bin/erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().')"
    echo "🧠 ElixirLS installed at: $(command -v elixir-ls)"
  '';
}
