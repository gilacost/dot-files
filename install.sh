#!/bin/bash
#
if ! which -s git; then
    # Install developer tools
    echo "Developer tools not installed, installing now..."
    # export PATH=/usr/bin:/bin:/usr/sbin

    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
          grep "\*.*Command Line" |
          head -n 1 | awk -F"*" '{print$2}' |
          sed -e 's/^ *//' |
          sed 's/Label: //g' |
          tr -d '\n')
    softwareupdate -i "$PROD" --verbose
    /usr/bin/make install
fi

if ! which -s brew; then
    # Install Homebrew
    echo "Brew not installed, installing now..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! which -s nix; then
    # Install Nix
    echo "Nix not installed, installing now..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi

# (if M1) softwareupdate --install-rosetta --agree-to-license

mkdir -p ~/.config/kitty

sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.old
sudo ln -s  "$HOME/Repos/dot-files/nix.conf" "/etc/nix/nix.conf"

# TODO move this to nix
ln -s  "$HOME/Repos/dot-files/conf.d/terminal/nvim.session" "$HOME/.config/nvim.session"
ln -s  "$HOME/Repos/dot-files/conf.d/terminal/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -s  "$HOME/Repos/dot-files/spell" "$HOME/.config/nvim"

nix build "./#darwinConfigurations.$(hostname).system"
./result/sw/bin/darwin-rebuild switch --flake "./#$(hostname)"
darwin-rebuild switch --flake "./#$(hostname)"

mkdir -p ~/.config/kitty
mkdir -p ~/.ssh
sudo rm  /etc/nix/nix.conf
sudo rm /etc/shells
touch ~/.zshrc_local

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
