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
      elixir-ls = super.stdenv.mkDerivation {
        pname = "elixir-ls";
        version = inputs.elixirLsVersion;

        src = super.fetchFromGitHub {
          owner = "elixir-lsp";
          repo = "elixir-ls";
          rev = inputs.elixirLsVersion;
          sha256 = inputs.elixirLsSha256;
        };

        buildInputs = [ self.elixir super.git ];

        # Fix: Provide a safe, temporary home directory
        buildPhase = ''
          export HOME=$(mktemp -d)
          export PATH=$PATH:${super.git}/bin
          export SSL_CERT_FILE=${super.cacert}/etc/ssl/certs/ca-bundle.crt
          export GIT_SSL_CAINFO=${super.cacert}/etc/ssl/certs/ca-bundle.crt
        
          mix local.hex --force
          mix local.rebar --force
        
          mix deps.get
          mix compile
          mix elixir_ls.release2 -o elixir-ls-release
        '';
        
        installPhase = ''
          mkdir -p $out/bin
          cp -r elixir-ls-release/* $out/bin/
        '';
      };
    })
  ];
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system overlays; };
  elixirLsBinPath = "${pkgs.elixir-ls}/bin/language_server.sh";
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
    builtins.concatLists [ [ erlang elixir elixir-ls] linuxPackages darwinPackages ];

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
    export ELIXIR_LS_PATH="${elixirLsBinPath}"

    echo "🍎 Erlang OTP-$(erl -eval '${escript}' -noshell)"
    echo "💧 $(${pkgs.elixir}/bin/elixir --version | tail -n 1)"
    echo "🧠 ElixirLS available at: $ELIXIR_LS_PATH"

    # Ensure global symlink exists
    mkdir -p "$HOME/.elixir-ls"

    if [ ! -e "$HOME/.elixir-ls/elixir-ls" ] || [ "$(readlink "$HOME/.elixir-ls/elixir-ls")" != "$ELIXIR_LS_PATH" ]; then
      ln -sf "$ELIXIR_LS_PATH" "$HOME/.elixir-ls/elixir-ls"
      echo "🔗 Symlinked ElixirLS to: $HOME/.elixir-ls/elixir-ls"
    fi
      
      echo "🧠 ElixirLS linked to: $HOME/.elixir-ls/elixir-ls"
    '';
}
