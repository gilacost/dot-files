# NOTE: Partially based on github.com/the-nix-way/dev-templates

inputs:
let
  overlays = [
    (self: super: rec {
      erlang = super.beam.interpreters.erlangR25.override {
        version = inputs.erlangVersion;
        sha256 = inputs.erlangSha256;
      };

      elixir = (super.beam.packagesWith erlang).elixir.override {
        version = inputs.elixirVersion;
        sha256 = inputs.elixirSha256;
      };
    })
  ];
  system = inputs.system;
  pkgs = import inputs.nixpkgs { inherit system overlays; };
in {
  devShells.default = pkgs.mkShell {
    buildInputs = (with pkgs; [ elixir ])
      ++ pkgs.lib.optionals (pkgs.stdenv.isLinux)
      (with pkgs; [ gigalixir inotify-tools libnotify ]) ++ # Linux only
      pkgs.lib.optionals (pkgs.stdenv.isDarwin)
      (with pkgs; [ terminal-notifier ]) ++ # macOS only
      (with pkgs.darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);

    shellHook = ''
      ${pkgs.elixir}/bin/mix --version
      ${pkgs.elixir}/bin/iex --version
    '';
  };

}
