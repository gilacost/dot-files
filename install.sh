#!/bin/bash


# ssh-keygen -t rsa -b 4096 -N '' -C "${REPLY}" -f ~/.ssh/github_rsa

if ! grep -q nix-darwin ~/.nix-channels; then
  echo "https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin" >> ~/.nix-channels
fi

nix-channel --update

export NIX_PATH=darwin=$HOME/.nix-defexpr/channels/darwin:$NIX_PATH    

sudo rm /etc/shells /etc/zprofile /etc/zshrc
nix-build '<darwin>' -A installer --out-link /tmp/nix-darwin && /tmp/nix-darwin/bin/darwin-installer

/tmp/nix-darwin/bin/darwin-installer -y
#'~/.nixpkgs/darwin-configuration.nix

ln -s  $HOME/Repos/dot-files/configuration.nix $HOME/.config/nixpkgs/darwin-configuration.nix

darwin-rebuild switch -I "darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix"

# HOME MANAGER

if ! grep -q home-manager ~/.nix-channels; then
  echo "https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager" >> ~/.nix-channels
fi

nix-channel --update
nix-shell '<home-manager>' -A install

ln -s  $HOME/Repos/dot-files/home.nix $HOME/.nixpkgs/home.nix
ln -s  $HOME/Repos/dot-files/colorscheme.nix $HOME/.nixpkgs/colorscheme.nix
ln -s  $HOME/Repos/dot-files/init.vim $HOME/.nixpkgse/init.vim
ln -s  $HOME/Repos/dot-files/kitty.conf $HOME/.config/kitty.conf
ln -s  $HOME/Repos/dot-files/nvim.session $HOME/.nvim.session

home-manager switch


