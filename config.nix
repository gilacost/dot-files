let pkgs = import <nixpkgs> { };
in {
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };
  nix = {
    package = pkgs.nixFlakes;
    # extraOptions =
    #   pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
    #   "experimental-features = nix-command flakes";
  };
  allowUnfree = true;
}
