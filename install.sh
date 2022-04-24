#!/bin/bash

# sh <(curl -L https://nixos.org/nix/install) --daemon
# TODO clone wallepapers https://github.com/catppuccin/wallpapers.git

DOT_FILES_REPO=$HOME/Repos/dot-files

mkdir -p ~/.config/kitty

sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.ol
sudo ln -s  $DOT_FILES_REPO/nix.conf /etc/nix/nix.conf

ln -s  $DOT_FILES_REPO/conf.d/terminal/nvim.session $HOME/.config/nvim.session
ln -s  $DOT_FILES_REPO/conf.d/terminal/kitty.conf $HOME/.config/kitty/kitty.conf
ln -s  $DOT_FILES_REPO/spell $HOME/.config/nvim/spell

nix build .#darwinConfigurations.lair.system
./result/sw/bin/darwin-rebuild switch --flake .#lair
darwin-rebuild switch --flake .#lair

# maybe error
# https://github.com/LnL7/nix-darwin/issues/451
# fucking monterrey requires you to switch the shell 'chsh -s /etc/profiles/per-user/pepo/bin/zsh'
