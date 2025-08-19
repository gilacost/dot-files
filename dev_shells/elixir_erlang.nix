# NOTE: Partially based on github.com/the-nix-way/dev-templates

inputs:
let
  overlays = [
    (self: super: rec {
      erlang = super.beam.interpreters.${inputs.erlangInterpreter}.override {
        sha256 = inputs.erlangSha256;
        version = inputs.erlangVersion;
      };

      elixir = (super.beam.packagesWith erlang).elixir.override (
        {
          sha256 = inputs.elixirSha256;
          version = inputs.elixirVersion;
        }
        // (
          if inputs ? elixirEscriptPath then
            {
              escriptPath = inputs.elixirEscriptPath;
            }
          else
            { }
        )
      );

      lexical = super.stdenv.mkDerivation {
        pname = "lexical";
        version = inputs.lexicalVersion;

        src = super.fetchurl {
          url = "https://github.com/lexical-lsp/lexical/releases/download/${inputs.lexicalVersion}/lexical.zip";
          sha256 = inputs.lexicalSha256;
        };

        nativeBuildInputs = [ super.unzip ];

        unpackPhase = ''
          unzip $src
        '';

        installPhase = ''
          mkdir -p $out
          cp -r * $out/
          # Make all files in bin directory executable
          if [ -d "$out/bin" ]; then
            chmod +x $out/bin/*
          fi
        '';
      };
    })
  ];
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system overlays; };
in
pkgs.mkShell {
  buildInputs =
    with pkgs;
    let
      linuxPackages = lib.optionals (stdenv.isLinux) [
        inotify-tools
        libnotify
      ];
      darwinPackages = lib.optionals (stdenv.isDarwin) (
        with darwin.apple_sdk.frameworks;
        [
          terminal-notifier
          CoreFoundation
          CoreServices
        ]
      );
    in
    builtins.concatLists [
      [
        erlang
        elixir
        lexical
      ]
      linuxPackages
      darwinPackages
    ];

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
      export LEXICAL_PATH="${pkgs.lexical}/bin/start_lexical.sh"

      export OTP_VERSION="$(erl -eval '${escript}' -noshell | tr -d '\n')"
      export ELIXIR_VERSION="$(${pkgs.elixir}/bin/elixir --version | grep 'Elixir' | awk '{print $2}')"

      echo "🍎 Erlang OTP-$OTP_VERSION"
      echo "💧 Elixir $ELIXIR_VERSION"
      echo "🧠 Lexical version: ${inputs.lexicalVersion}"

      # Remove existing directory/symlink if it exists
      rm -rf "$HOME/.elixir-lsp/lexical"

      # Link the correct lexical binary
      ln -sf "${pkgs.lexical}/" "$HOME/.elixir-lsp/lexical"
      echo "🔗 Symlinked Lexical to: $HOME/.elixir-lsp/lexical"
      echo "🧠 Lexical available at: ${pkgs.lexical}/bin/start_lexical.sh"
      echo ""
    '';
}
