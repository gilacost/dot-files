#!/usr/bin/env bash
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

brew tap koekeishiya/formulae
#brew install
PACKAGES=(
    tidy-html5
    watch
    asdf
    autoconf
    awscli
    az
    bat
    cloc
    coreutils
    curl
    defaultbrowser
    direnv
    fzf
    git
    gpg
    gpg1
    graphviz
    jq
    koekeishiya/formulae/skhd
    lsd
    neovim
    nvm
    peco
    pre-commit
    python3
    rename
    ripgrep
    terminal-notifier
    tflint
    tig
    tree
    wget
    wxmac
    zsh
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

# GPG
brew upgrade gnupg
brew link --overwrite gnupg
brew install pinentry-mac
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent
echo "test" | gpg --clearsign

read -p "Do you want to generate a new ssh key for github?" -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "input your email:" -r; echo
  echo "generating ssh key for ${REPLY}"
  ssh-keygen -t rsa -b 4096 -N '' -C "${REPLY}" -f ~/.ssh/github_rsa
fi

#asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2

#install asdf plugins
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

echo "Cleaning up..."
brew cleanup

#ZSH pluggins
mkdir -p $HOME/.oh-my-zsh/plugins
cd $HOME/.oh-my-zsh/plugins
git clone https://github.com/gusaiani/elixir-oh-my-zsh.git elixir
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
git clone https://github.com/romkatv/powerlevel10k.git ../themes/powerlevel10k

#language server elixir
git clone git@github.com:elixir-lsp/elixir-ls.git ~/elixir-ls

echo "Installing cask..."
brew cask
brew install caskroom/cask/brew-cask
brew tap dorukgezici/cask

CASKS=(
    zoomus
    diffmerge
    kitty
    docker
    flux
    spotify
    google-chrome
    google-cloud-sdk
    vlc
    1password
    grammarly
    popcorn-time
    recordit
    notion
    karabiner-elements
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Installing fonts..."
# brew tap caskroom/fonts
# FONTS=(
#     font-fontawesome
#     therm
# )

brew cask install ${FONTS[@]}

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    neovim
    neovim-remote
    aws-cli
)
MACOSX_DEPLOYMENT_TARGET=10.15
pip3 install --user ${PYTHON_PACKAGES[@]}
#pip2 install --user ${PYTHON_PACKAGES[@]}
#todo install ruby neovim and npm neovim

echo "Configuring OSX..."
#set default browser to be firefox
defaultbrowser chrome

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

echo "Auto hide dock"
# Auto hide dock
defaults write com.apple.Dock autohide -bool TRUE; killall Dock

echo "Enable tap-to-click"
# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "show battery percentage"
# show battery percentage
defaults write com.apple.menuextra.battery ShowPercent YES

#bluetooth in menu bar
open '/System/Library/CoreServices/Menu Extras/Bluetooth.menu'

echo "auto hide menu bar"
# auto hide menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# installing dotfiles
cd $HOME/Repos/dot-files/ && make

echo "Bootstrapping complete"
