#!/bin/bash

# sh <(curl -L https://nixos.org/nix/install) --daemon
# TODO clone wallepapers https://github.com/catppuccin/wallpapers.git


mkdir -p ~/.config/kitty

sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.ol
sudo ln -s  $HOME/Repos/dot-files/nix.conf /etc/nix/nix.conf

ln -s  $HOME/Repos/dot-files/conf.d/terminal/nvim.session $HOME/.config/nvim.session
ln -s  $HOME/Repos/dot-files/conf.d/terminal/kitty.conf $HOME/.config/kitty/kitty.conf
ln -s  $HOME/Repos/dot-files/spell $HOME/.config/nvim

nix build .#darwinConfigurations.lair.system
./result/sw/bin/darwin-rebuild switch --flake ./\#lair
darwin-rebuild switch --flake ./\#lair

# maybe error
# https://github.com/LnL7/nix-darwin/issues/451
# fucking monterrey requires you to switch the shell 'chsh -s /etc/profiles/per-user/pepo/bin/zsh'
rm -fr $(brew --repo homebrew/core)  # because you can't `brew untap homebrew/core`
brew tap homebrew/core
mkdir -p ~/.config/kitty
sudo rm  /etc/nix/nix.conf
sudo rm /etc/shells
