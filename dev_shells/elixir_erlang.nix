# NOTE: Partially based on github.com/the-nix-way/dev-templates

inputs:
let
  overlays = [
    (self: super: rec {
      # Use default erlang from nixpkgs instead of specific version
      # to avoid apple_sdk_11_0 compatibility issues in CI
      erlang = super.beam.interpreters.erlang;

      elixir = (super.beam.packagesWith erlang).elixir;

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

    } // (
      if inputs ? expert then
        {
          expert = inputs.expert.packages.${system}.default;
        }
      else
        { }
    ))
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
      darwinPackages = lib.optionals (stdenv.isDarwin) [
        terminal-notifier
        # CoreFoundation and CoreServices are provided by stdenv on Darwin
      ];
    in
    builtins.concatLists [
      [
        erlang
        elixir
        lexical
      ]
      (lib.optionals (inputs ? expert) [ expert ])
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
      ${pkgs.lib.optionalString (inputs ? expert) ''
        echo "🚀 Expert available at: ${pkgs.expert}/bin/expert"
      ''}

      # Create .elixir-lsp directory if it doesn't exist
      mkdir -p "$HOME/.elixir-lsp"

      # Remove existing directory/symlink if it exists
      rm -rf "$HOME/.elixir-lsp/lexical"
      ${pkgs.lib.optionalString (inputs ? expert) ''
        rm -rf "$HOME/.elixir-lsp/expert"
      ''}

      # Link lexical (primary/stable LSP)
      ln -sf "${pkgs.lexical}/lexical" "$HOME/.elixir-lsp/lexical"
      echo "🔗 Symlinked Lexical to: $HOME/.elixir-lsp/lexical"
      echo "🧠 Lexical available at: ${pkgs.lexical}/lexical/bin/start_lexical.sh"

      ${pkgs.lib.optionalString (inputs ? expert) ''
        # Link expert (experimental LSP)
        ln -sf "${pkgs.expert}/bin/expert" "$HOME/.elixir-lsp/expert"
        echo "🚀 Expert available at: $HOME/.elixir-lsp/expert"
      ''}
      echo ""
    '';
}
