{ pkgs, ... }:
let

  # gabe565/gh-profile
  # maybe 1PASSWORD stuff 
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

  gh-profile = pkgs.buildGoModule rec {
    pname = "gh-profile";
    version = "1.3.2";

    src = pkgs.fetchFromGitHub {
      owner = "gabe565";
      repo = "gh-profile";
      rev = "71a0a267052659f7ae189282a5bc56d69a4d5913";
      sha256 = "1zxww52p74pmlcahmi834nc3qzl2f4rykb4nlwjn3mcyd144il57";
    };

    vendorHash = "sha256-52VHV3PPA3U71TpaVdjYcmAJpBsRSowJGJFs3xbgq1Y=";
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

  gh-combine-prs = pkgs.stdenv.mkDerivation {
    pname = "gh-combine-prs";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "rnorth";
      repo = "gh-combine-prs";
      rev = "ab066c1d810844c071a661301259cbb470891004";
      sha256 = "00ngb8ay8sl460cp962zbrcap6x1alpqdj4c3gpdga7ah37ks612";
    };

    buildInputs = [ pkgs.bash ];
    buildCommand = ''
      mkdir -p $out/bin $out/dist
      cp -r $src/* $out/bin
      chmod +x $out/bin/gh-combine-prs
    '';

    meta = with pkgs.lib; {
      description =
        "A `gh` extension for combining multiple PRs (e.g. Dependabot PRs) into one. ";
    };
  };

in {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-profile
      gh-markdown-preview
      gh-poi
      gh-clone-org
      gh-combine-prs
    ];
    settings = { git_protocol = "ssh"; };
  };
}
