{ pkgs, ... }:
let
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
in {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview gh-poi ];
    settings = { git_protocol = "ssh"; };
  };
}
