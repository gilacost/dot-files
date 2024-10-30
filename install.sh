#!/bin/bash

if ! which -s brew; then
    # Install Homebrew
    echo "Brew not installed, installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! which -s nix; then
    # Install Nix
    VERSION='2.11.0'
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

# (if M1) softwareupdate --install-rosetta --agree-to-license

mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/zellij"

SCRIPT_DIR=$(dirname "$0")

# sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.old
# sudo ln -s  "$HOME/Repos/$SCRIPT_DIR/nix.conf" "/etc/nix/nix.conf"

# TODO move this to nix
ln -s  "$HOME/Repos/$SCRIPT_DIR/conf.d/terminal/nvim.session" "$HOME/.config/nvim.session"
ln -s  "$HOME/Repos/$SCRIPT_DIR/conf.d/terminal" "$HOME/.config/kitty/kitty.conf"
ln -s  "$HOME/Repos/$SCRIPT_DIR/conf.d/zellij" "$HOME/.config/zellij"
ln -s  "$HOME/Repos/$SCRIPT_DIR/spell" "$HOME/.config/nvim"

# TODO check hostname?

nix build "./#darwinConfigurations.$(hostname).system"
./result/sw/bin/darwin-rebuild switch --flake "./#$(hostname)"
darwin-rebuild switch --flake "./#$(hostname)"

mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.ssh"
sudo rm  /etc/nix/nix.conf
sudo rm /etc/shells
touch "$HOME/.zshrc_local"

# TODO 

# the firefox profile
# gpg --import secrets/g.key
# $ printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
# $ /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -B # For Catalina
# $ /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t # For Big Sur and later
# rm /etc/nix/nix.conf already exists, skipping...
# cat GITCRYPTKEY | base64 --decode > GITCRYPTK
# git-crypt unlock GITCRYPTK
# cp secrets/wt.cfg.key ~/.wakatime.cfg
