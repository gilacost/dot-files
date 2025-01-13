# NOTE: Partially based on github.com/the-nix-way/dev-templates

inputs:
let
  overlays = [
    (self: super: rec {
      erlang = super.beam.interpreters.${inputs.erlangInterpreter}.override {
        sha256 = inputs.erlangSha256;
        version = inputs.erlangVersion;
      };

      elixir = (super.beam.packagesWith erlang).elixir.override ({
        sha256 = inputs.elixirSha256;
        version = inputs.elixirVersion;
      } // (if inputs ? elixirEscriptPath then {
        escriptPath = inputs.elixirEscriptPath;
      } else
        { }));
    })
  ];
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system overlays; };
in
pkgs.mkShell {
  buildInputs = with pkgs;
    let
      linuxPackages =
        lib.optionals (stdenv.isLinux) [ inotify-tools libnotify ];
      darwinPackages = lib.optionals (stdenv.isDarwin)
        (with darwin.apple_sdk.frameworks; [
          terminal-notifier
          CoreFoundation
          CoreServices
        ]);
    in
    builtins.concatLists [ [ erlang elixir ] linuxPackages darwinPackages ];

  shellHook =
    let
      escript = ''
        Filepath = filename:join([
          code:root_dir(),
          "releases",
          erlang:system_info(otp_release),
          "OTP_VERSION"
        ]),
        {ok, Version} = file:read_file(Filepath),
        io:fwrite(Version),
        halt().
      '';
    in
    ''
      echo "🍎 Erlang OTP-$(erl -eval '${escript}' -noshell)"
      echo "💧 $(${pkgs.elixir}/bin/elixir --version | tail -n 1)"
    '';
}
