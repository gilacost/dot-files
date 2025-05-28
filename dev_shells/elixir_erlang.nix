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
          super.makeWrapper
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
        '';

        installPhase = ''
                  mix package --path "$out"
                  chmod +x $out/bin/*.sh

                  # Create a wrapper script with version support
                  mv "$out/bin/start_lexical.sh" "$out/bin/start_lexical.sh.orig"
                  cat > "$out/bin/start_lexical.sh" << EOF
          #!/bin/sh

          if [ "\$1" = "--version" ] || [ "\$1" = "-v" ]; then
              echo "${inputs.lexicalVersion}"
              exit 0
          fi

          exec "$out/bin/start_lexical.sh.orig" "\$@"
          EOF
                  chmod +x "$out/bin/start_lexical.sh"

                  # Add Nix detection to version manager script
                  substituteInPlace "$out/bin/activate_version_manager.sh" \
                    --replace-fail 'activate_version_manager() {' '
          activate_version_manager() {
              if [ -n "$IN_NIX_SHELL" ]; then
                  echo >&2 "Using Nix-provided Elixir: $(which elixir)"
                  return 0
              fi'
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
      export LEXICAL_PATH="${pkgs.lexical}/bin/lexical"

      export OTP_VERSION="$(erl -eval '${escript}' -noshell | tr -d '\n')"
      export ELIXIR_VERSION="$(${pkgs.elixir}/bin/elixir --version | grep 'Elixir' | awk '{print $2}')"

      echo "🍎 Erlang OTP-$OTP_VERSION"
      echo "💧 Elixir $ELIXIR_VERSION"
      echo "🧠 Lexical version: ${inputs.lexicalVersion}"
      echo ""

      # Remove existing directory/symlink if it exists
      rm -rf "$HOME/.elixir-lsp/lexical"

      # Link the correct lexical binary
      ln -sf "${pkgs.lexical}/" "$HOME/.elixir-lsp/lexical"
      echo "🔗 Symlinked Lexical to: $HOME/.elixir-lsp/lexical"
      echo "🧠 Lexical available at: ${pkgs.lexical}/bin/start_lexical.sh"
    '';
}
