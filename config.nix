let pkgs = import <nixpkgs> { };
in {
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };
  nix.package = pkgs.nixUnstable;
  allowUnfree = true;
}
