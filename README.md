* My configuration
  [[https://builtwithnix.org][https://img.shields.io/badge/Built_With-Nix-5277C3.svg?logo=nixos&labelColor=73C3D5]]

  OSX configurations, expressed in [[https://nixos.org/nix][Nix]]

* Installation requirements

In order to be able to install some casks we require `homebrew` installed.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off
```

## Casks list

```nix
  homebrew.casks = [
   "firefox"
   "1password"
   "docker"
   "grammarly"
   "inkscape"
   "recordit"
   "spotify"
   "vlc"
   "zoom"
   "kitty"
  ];
```

## Install nix

**NOTE**: If you decide to encrypt the main Drive by enabling file vault, you will needwe need to create the `/nix` volume mannually. Follow these [instructions]
(https://nixos.org/manual/nix/stable/#sect-macos-installation-recommended-notes)

### Steps

1) `sudo echo "nix" > /etc/synthetic.conf`

2) `sudo diskutil apfs addVolume disk1 APFS 'Nix Store' -mountpoint /nix`

3)`sudo vifs
LABEL=Nix\040Store /nix apfs rw,nobrowse
`

4) `sudo reboot`

5) `curl -L https://nixos.org/nix/install | sh -s -- --daemon`

6) `./install.sh`

## Useful commands

* `nix-shell -p nix-info --run "nix-info -m"`

next steps: 
- zsh and all programs with home manager
- keyboard language? enable and uk?
- review all vim plugins
- ale and language-servers
- secrets in repo
- move to flakes
- yabai
- sort ligatures
- play with telescope
- import snipets not prioritary
