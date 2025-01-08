#!/bin/bash

HOSTNAME=${HOSTNAME:-buque}

if ! which -s brew; then
    # Install Homebrew
    echo "Brew not installed, installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! which -s nix; then
    # Install Nix
    VERSION='2.25.3'
    echo "Nix not installed, installing now version ${VERSION}..."
    URL="https://releases.nixos.org/nix/nix-${VERSION}/install"
    CONFIGURATION="
    extra-experimental-features = nix-command flakes repl-flake 
    extra-trusted-users = ${USER}
    "
    sh <(curl --location "${URL}") --daemon \
        --no-channel-add \
        --nix-extra-conf-file <(echo "${CONFIGURATION}")
fi

softwareupdate --install-rosetta --agree-to-license

mkdir -p "$HOME/.config/kitty"

SCRIPT_DIR=$(dirname "$0")

sudo ln -s  "$HOME/Repos/$SCRIPT_DIR/nix.conf" "/etc/nix/nix.conf"

# TODO move this to nix
ln -s  "$HOME/Repos/$SCRIPT_DIR/conf.d/terminal/nvim.session" "$HOME/.config/nvim.session"
ln -s  "$HOME/Repos/$SCRIPT_DIR/conf.d/terminal" "$HOME/.config/kitty/kitty.conf"
ln -s  "$HOME/Repos/$SCRIPT_DIR/spell" "$HOME/.config/nvim"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.ssh"

sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $HOSTNAME
sudo scutil --set ComputerName $HOSTNAME
dscacheutil -flushcache

# TODO if no nix print message indicating to reboot the shell and exit

nix build "./#darwinConfigurations.$(hostname).system"
mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
./result/sw/bin/darwin-rebuild switch --flake "./#$(hostname)"
darwin-rebuild switch --flake "./#$(hostname)"

touch "$HOME/.zshrc_local"

# TODO 
# configure right click of the magic mouse
# gpg --import secrets/g.key
# cat GITCRYPTKEY | base64 --decode > GITCRYPTK
# git-crypt unlock GITCRYPTK
# cp secrets/wt.cfg.key ~/.wakatime.cfg
