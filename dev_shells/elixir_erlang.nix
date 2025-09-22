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

      expert = inputs.expert.packages.${system}.default;
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
        expert
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
      export OTP_VERSION="$(erl -eval '${escript}' -noshell | tr -d '\n')"
      export ELIXIR_VERSION="$(${pkgs.elixir}/bin/elixir --version | grep 'Elixir' | awk '{print $2}')"

      echo "🍎 Erlang OTP-$OTP_VERSION"
      echo "💧 Elixir $ELIXIR_VERSION"
      echo "🚀 Expert available at: ${pkgs.expert}/bin/expert"

      # Create .elixir-lsp directory if it doesn't exist
      mkdir -p "$HOME/.elixir-lsp"

      # Remove existing directory/symlink if it exists
      rm -rf "$HOME/.elixir-lsp/expert"

      # Link the expert binary
      ln -sf "${pkgs.expert}/bin/expert" "$HOME/.elixir-lsp/expert"
      echo "🔗 Linked Expert to: $HOME/.elixir-lsp/expert"
      echo ""
    '';
}
