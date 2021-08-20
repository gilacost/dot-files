# My configuration


![https://builtwithnix.org](https://img.shields.io/badge/Built_With-Nix-5277C3.svg?logo=nixos&labelColor=73C3D5)

OSX configurations, expressed in [Nix](https://nixos.org/nix)

## Installation requirements

`homebrew` installed to enable `casks`.

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
- is colorschem even needed
- functions zsh
- git extra config
- review all lspsga commands with maps
- play with telescope
- acabar el tour
- erlan-ls
- review all maps
- keyboard language? enable and uk?
- review all vim plugins
- review all confs with alvivi's and tidy owns
- ale and language-servers
- secrets in repo
- move to flakes
- yabai
- sort ligatures
- import snipets not prioritary
