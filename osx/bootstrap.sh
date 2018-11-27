#!/bin/bash

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

# Brew 

if ! [ -x "$(command -v brew)" ]; then
  read -p "Install Brew (OS X Package Manager)? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask
  fi
fi

# Git

read -p "Do you want to update git? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew install git
fi

read -p "Do you want to configure git? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "Name? " -r
  git config --global user.name "$REPLY"
  read -p "Email? " -r
  git config --global user.email "$REPLY"
  echo "Now configure you SSH and GPG keys in GitHub, GitLab, BitBucket, etc."
  echo "GO TO: https://gist.github.com/bmhatfield/cc21ec0a3a2df963bffa3c1f884b676b"
  exit 0
fi

# Keyboard

if ! [ -d /Applications/Karabiner-Elements.app ]; then
  read -p "Configure the Keyboard? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    defaults write -g ApplePressAndHoldEnabled -bool true
    defaults write -g InitialKeyRepeat -int 10
    defaults write -g KeyRepeat -int 1
    brew cask install karabiner-elements
    mkdir -p ~/.config/karabiner
    cp -f ./karabiner/karabiner.json  ~/.config/karabiner/karabiner.json 
    echo "L_CAP_LOCK remapped to CTRL/ESC. Restart the system now"
    exit 0
  fi
fi

# Window Tiling

if ! [ -x "$(command -v chunkwm)" ]; then
  read -p "Install chunkwm/skhd? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew tap crisidev/homebrew-chunkwm
    brew install chunkwm
    brew install koekeishiya/formulae/skhd
    cp ./skhd/skhdrc ~/.skhdrc
    cp ./chunkwm/chunkwmrc ~/.chunkwmrc
    brew services restart chunkwm
    brew services restart skhd
  fi
fi

# Firefox 

if ! [ -d /Applications/Firefox.app ]; then
  read -p "Install Firefox? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew cask install firefox
    brew install defaultbrowser
    defaultbrowser firefox
    echo "Now manually install uBlock, TST and userChrome.css (available in firefox folder)"
    exit 0
  fi
fi

# Franz (Mail / IM)

if ! [ -d /Applications/Franz.app ]; then
  read -p "Install Franz? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew cask install franz
  fi
fi
