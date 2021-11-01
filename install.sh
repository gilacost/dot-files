#!/bin/bash

#  ssh-keygen -t rsa -b 4096 -N '' -C "EMAIL" -f ~/.ssh/github_rsa

mkdir -p ~/.config/nixpkgs
mkdir -p ~/.nixpkgs

ln -s  $HOME/Repos/dot-files/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix
ln -s  $HOME/Repos/dot-files/darwin-configuration.nix $HOME/.config/nixpkgs/darwin-configuration.nix
ln -s  $HOME/Repos/dot-files/config.nix $HOME/.config/nixpkgs/config.nix
DOT_DIR=$HOME/Repos/dot-files
ln -s  $DOT_DIR/home.nix $HOME/.nixpkgs/home.nix
ln -s  $DOT_DIR/conf.d/terminal/nvim.session $HOME/.config/nvim.session
ln -s  $DOT_DIR/conf.d/terminal/kitty.conf $HOME/.config/kitty/kitty.conf

# Configure the channel

if ! grep -q nix-darwin ~/.nix-channels; then
  echo "https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin" >> ~/.nix-channels
fi
export NIX_PATH=darwin=$HOME/.nix-defexpr/channels/darwin:$NIX_PATH

if ! grep -q home-manager ~/.nix-channels; then
  echo "https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager" >> ~/.nix-channels
fi
export NIX_PATH=home-manager=$HOME/.nix-defexpr/channels/home-manager:$NIX_PATH
export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
nix-channel --update

echo $NIX_PATH
sudo rm /etc/shells /etc/zprofile /etc/zshrc
nix-build '<darwin>' -A installer --out-link /tmp/nix-darwin && /tmp/nix-darwin/bin/darwin-installer

# Isn't it supposed to do this? It doesn't.
rm -rf /run/*
ln -shf /nix/store/$(ls /nix/store | grep darwin-system- | grep -v drv | head -1) /run/current-system

/run/current-system/sw/bin/darwin-rebuild switch

# . /etc/static/bashrc
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

# NODE DERIVATIONS
nix-env -i -f modules/node/default.nix
# NUR
nix-env -f '<nixpkgs>' -iA nur.repos.mic92.hello-nur
# NIXUINSTABLE
nix-env -iA nixpkgs.nixUnstable
# HOME MANAGER
nix-shell '<home-manager>' -A install
home-manager switch
/run/current-system/sw/bin/darwin-rebuild switch

# mkdir -p $HOME/.config/rebar3
# ln -s  $DOT_DIR/conf.d/rebar.conf $HOME/.config/rebar3/rebar.conf
# ln -s  $DOT_DIR/conf.d/direnvrc $HOME/.direnvrc
# nix-env -iA nixpkgs.nixUnstable
# nix build ./\#darwinConfigurations.homebook.system
# ./result/sw/bin/darwin-rebuild switch --flake ./
ln -s  $HOME/Repos/dot-files/spell $HOME/.config/nvim/spell
# nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
# nix upgrade-nix
