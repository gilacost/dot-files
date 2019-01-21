#!/usr/bin/env bash
# TODO(pepito) make a session with chunkwm and skhd to make kitty work with alvivi
# TODO(set iterm appeaeance dark)
#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#

# Custom Host Name
HOSTNAME_RESULT="$(scutil --get HostName 2>&1 > /dev/null)"
if [[ $HOSTNAME_RESULT =~ "not set" ]]; then
  read -p "Do you want to change the computer name? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "New Computer Name: " -r; echo
    sudo scutil --set HostName $REPLY
    echo "Restart terminal session to see results"
  fi
fi

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

brew tap crisidev/homebrew-chunkwm

#brew install
PACKAGES=(
    direnv
    asdf
    chunkwm
    koekeishiya/formulae/skhd
    neovim
    python3
    ack
    git
    graphviz
    nvm
    zsh
    fzf
    rename
    the_silver_searcher
    tree
    wget
    curl
    defaultbrowser
    task
)

read -p "Do you want to generate a new ssh key for github?" -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "input your email:" -n 1 -r; echo
  echo "generating ssh key for ${REPLY}"
  ssh-keygen -t rsa -b 4096 -N '' -C "${REPLY}" -f ~/.ssh/github_rsa
fi

read -p "Task Warrior?" -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git clone git@github.com:gilacost/task.git ~/.task
fi
    #peco
    #ssh-copy-id
    #terminal-notifier

#asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2

#install asdf plugins
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

#task warriror synk
git clone git@github.com:gilacost/task.git ~/.task

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew cask
# brew install caskroom/cask/brew-cask

# echo "installing GPG"
# brew upgrade gnupg  # This has a make step which takes a while
# brew link --overwrite gnupg
# brew install pinentry-mac
# echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
# killall gpg-agent
# echo "test" | gpg --clearsign  # on linux it's gpg2 but brew stays as gpg

CASKS=(
    kitty
    iterm2
    docker
    flux
    spotify
    franz
    firefox
    google-chrome
    slack
    vlc
)
    #spectacle
    #karabiner-elements

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-hack-nerd-font
    font-hack-nerd-font-mono
    font-firacode-nerd-font
    font-firacode-nerd-font-mono
)
brew cask install ${FONTS[@]}

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    neovim-remote
)
sudo pip3 install ${PYTHON_PACKAGES[@]}

#echo "Installing global npm packages..."
#npm install marked -g

echo "Configuring OSX..."
#set default browser to be firefox
defaultbrowser firefox

echo "ESTO NO SE QUE ES..."
#Esto no se que es
defaults write -g ApplePressAndHoldEnabled -bool true

echo "Set fast key repeat rate"
# Set fast key repeat rate
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

echo "Require password as soon as screensaver or sleep mode starts"
# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Show filename extensions by default"
# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Enable tap-to-click"
# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "show battery percentage"
# show battery percentage
defaults write com.apple.menuextra.battery ShowPercent YES

#bluetooth in menu bar
open '/System/Library/CoreServices/Menu Extras/Bluetooth.menu'

echo "auto hide menu bar"
# auto hide menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# installing dotfiles
make install

echo "Bootstrapping complete"
