#!/bin/bash

# ssh-keygen -t rsa -b 4096 -N '' -C "${REPLY}" -f ~/.ssh/github_rsa

sudo ln -s private/var/run /run
mkdir -p ~/.config

# Configure the channel
nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --update
export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH

# Or use a local git repository
git clone git@github.com:LnL7/nix-darwin.git ~/.nix-defexpr/darwin
export NIX_PATH=darwin=$HOME/.nix-defexpr/darwin:darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$NIX_PATH

ln -s  $HOME/Repos/dot-files/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix
ln -s  $HOME/Repos/dot-files/darwin-configuration.nix $HOME/.config/nixpkgs/darwin-configuration.nix

# you can also use this to rebootstrap nix-darwin in case
# darwin-rebuild is to old to activate the system.
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch

. /etc/static/bashrc

# NODE DERIVATIONS

nix-env -i -f modules/node/default.nix

# NUR

ln -s  $HOME/Repos/dot-files/config.nix $HOME/.config/nixpkgs/config.nix
nix-env -f '<nixpkgs>' -iA nur.repos.mic92.hello-nur

# HOME MANAGER

if ! grep -q home-manager ~/.nix-channels; then
  echo "https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager" >> ~/.nix-channels
fi

nix-channel --update
nix-shell '<home-manager>' -A install

DOT_DIR=$HOME/Repos/dot-files

ln -s  $DOT_DIR/home.nix $HOME/.nixpkgs/home.nix
ln -s  $DOT_DIR/conf.d/terminal/nvim.session $HOME/.config/nvim.session
ln -s  $DOT_DIR/conf.d/terminal/kitty.conf $HOME/.config/kitty/kitty.conf

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
#home manager not found in path

home-manager switch

# mkdir -p $HOME/.config/rebar3
# ln -s  $DOT_DIR/conf.d/rebar.conf $HOME/.config/rebar3/rebar.conf

# ln -s  $DOT_DIR/conf.d/direnvrc $HOME/.direnvrc
# nix-env -iA nixpkgs.nixUnstable


# nix build ./\#darwinConfigurations.homebook.system
# ./result/sw/bin/darwin-rebuild switch --flake ./
