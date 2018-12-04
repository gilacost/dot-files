#!/usr/bin/env bash
# TODO(pepito) make a session with chunkwm and skhd to make kitty work with alvivi
# TODO(pepiro) git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2
# TODO(pepito) install asdf plugins
# TODO(pepito) echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
# TODO(pepito) echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
# asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
# asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
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
)
    #peco
    #ssh-copy-id
    #terminal-notifier


echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew cask
# brew install caskroom/cask/brew-cask

CASKS=(
    kitty
    iterm2
    docker
    spotify
    franz
    firefox
    flux
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

# echo "Installing Ruby gems"
# RUBY_GEMS=(
#     bundler
#     filewatcher
#     cocoapods
# )
# sudo gem install ${RUBY_GEMS[@]}

echo "Configuring OSX..."
#set default browser to be firefox
defaultbrowser firefox

#Esto no se que es
defaults write -g ApplePressAndHoldEnabled -bool true

# Set fast key repeat rate
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#TODO(sort show bluetooth in bar and battery percentage)
#TODO(dark top bar)
#TODO (auto hide menu bar)

# installing dotfiles
make install

echo "Bootstrapping complete"
