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

        src = super.fetchFromGitHub {
          owner = "lexical-lsp";
          repo = "lexical";
          rev = inputs.lexicalVersion;
          sha256 = inputs.lexicalSha256;
        };

        buildInputs = [
          self.elixir
          super.git
        ];

        buildPhase = ''
          export HOME=$(mktemp -d)
          export PATH=$PATH:${super.git}/bin
          export SSL_CERT_FILE=${super.cacert}/etc/ssl/certs/ca-bundle.crt
          export GIT_SSL_CAINFO=${super.cacert}/etc/ssl/certs/ca-bundle.crt

          mix local.hex --force
          mix local.rebar --force
          mix deps.get
          mix deps.compile
          mix compile --warnings-as-errors
          mix package
        '';

        installPhase = ''
          mkdir -p $out/package
          cp -r _build/dev/package/lexical/* $out/package
          chmod +x $out/package
          chmod +x $out/package/bin/*.sh
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
      export LEXICAL_PATH="${pkgs.lexical}/package"

      export OTP_VERSION="$(erl -eval '${escript}' -noshell | tr -d '\n')"
      export ELIXIR_VERSION="$(${pkgs.elixir}/bin/elixir --version | grep 'Elixir' | awk '{print $2}')"

      echo "🍎 Erlang OTP-$OTP_VERSION"
      echo "💧 Elixir $ELIXIR_VERSION"
      echo "🧠 Lexical version: ${inputs.lexicalVersion}"
      echo ""

      # Remove existing directory/symlink if it exists
      rm -rf "$HOME/.elixir-lsp/lexical"
      mkdir -p "$HOME/.elixir-lsp"

      ln -sf "$LEXICAL_PATH" "$HOME/.elixir-lsp/lexical"
      echo "🔗 Symlinked Lexical package to: $HOME/.elixir-lsp/lexical"
      echo "🧠 Lexical path in store at: $LEXICAL_PATH"
      echo "🧠 Lexical start path at: $HOME/.elixir-lsp/lexical/bin/start_lexical.sh"
    '';
}
