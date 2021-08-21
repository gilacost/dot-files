let
  mixOverlay = builtins.fetchGit {
    url = "https://github.com/hauleth/nix-elixir.git";
  };
  nixpkgs = import <nixpkgs> {
    overlays = [ (import mixOverlay) ];
  };
in nixpkgs.beam.packages.erlang.elixir-ls
