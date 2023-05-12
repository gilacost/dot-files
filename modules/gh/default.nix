{ pkgs, ... }:
let

  # gabe565/gh-profile
  # rnorth/gh-combine-prs
  #  TODO gh search repos --topic "gh-extension"
  gh-poi = pkgs.buildGoModule rec {
    pname = "gh-poi";
    version = "0.9.1";

    src = pkgs.fetchFromGitHub {
      owner = "seachicken";
      repo = "gh-poi";
      rev = "v${version}";
      hash = "sha256-7KZSZsYfo9zZ0HSg5yLDNTlwb30byD73kqMNHc0tQpo=";
    };

    vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";
    doCheck = false;
  };

  gh-clone-org = pkgs.stdenv.mkDerivation {
    pname = "gh-clone-org";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "matt-bartel";
      repo = "gh-clone-org";
      rev = "1036c0f1d04ef70af92c28b7818d14c5f99ca572";
      sha256 = "022hsncmhwd3vyvfkihd9667k0hp9hy3zddym1jyyakfj94dh9rj";
    };

    buildInputs = [ pkgs.bash ];
    buildCommand = ''
      mkdir -p $out/bin $out/dist
      cp -r $src/* $out/bin
      chmod +x $out/bin/gh-clone-org
    '';

    meta = with pkgs.lib; {
      description = "Clone all repos in a GitHub organization";
    };
  };

in {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview gh-poi gh-clone-org ];
    settings = { git_protocol = "ssh"; };
  };
}
