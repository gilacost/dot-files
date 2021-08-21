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

ln -s  $HOME/Repos/dot-files/configuration.nix $HOME/.config/nixpkgs/darwin-configuration.nix

darwin-rebuild switch -I "darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix"

# DERIVATIONS

# nix-env -i -f erlangls.nix
nix-env -i -f modules/elixirls.nix
nix-env -i -f modules/node/default.nix

# HOME MANAGER

if ! grep -q home-manager ~/.nix-channels; then
  echo "https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager" >> ~/.nix-channels
fi

nix-channel --update
nix-shell '<home-manager>' -A install

DOT_DIR=$HOME/Repos/dot-files

ln -s  $DOT_DIR/home.nix $HOME/.nixpkgs/home.nix
ln -s  $DOT_DIR/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix

ln -s  $DOT_DIR/conf.d/editor/init.vim $HOME/.config/init.vim
ln -s  $DOT_DIR/conf.d/editor/init.lua $HOME/.config/init.lua

ln -s  $DOT_DIR/conf.d/terminal/nvim.session $HOME/.config/nvim.session
ln -s  $DOT_DIR/conf.d/terminal/kitty.conf $HOME/.config/kitty.conf

home-manager switch
