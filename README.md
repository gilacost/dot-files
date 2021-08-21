# My dot-files


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

**NOTE**: If you decide to encrypt the main Drive by enabling file vault, you will need to create the `/nix` volume manually. Follow these [instructions](https://nixos.org/manual/nix/stable/#sect-macos-installation-recommended-notes).

### Steps

1) `sudo echo "nix" > /etc/synthetic.conf`

2) `sudo diskutil apfs addVolume disk1 APFS 'Nix Store' -mountpoint /nix`

3) `sudo vifs LABEL=Nix\040Store /nix apfs rw,nobrowse`

4) `sudo reboot`

5) `curl -L https://nixos.org/nix/install | sh -s -- --daemon`

6) `./install.sh`

## Useful commands

* `nix-shell -p nix-info --run "nix-info -m"`

next steps:
- fix fzf --hidden files
- prettier
- play with telescope
- lua terraform and nix language servers
- acabar el tour
- erlan-ls, clone and import local overlay
- review all maps
- keyboard language? enable and uk?
- review all vim plugins
- review compe plugin
- review all confs with alvivi's and tidy owns
- yabai
- move to flakes
- sort ligatures
- import snipets not prioritary
- reorder folder (refactor and tidy)
- dissable alias suggestion

## SSH

## GPG

1) generate new gpg key

```bash
gpg --full-generate-key
```

2) show id for previous export, the id is after the '/'

```bash
 gpg --list-secret-keys --keyid-format LONG
```

3) export public key

```bash
 gpg --armor --export REPLACE_WITH_EXTRACTED_ID
```

4) display id short version for gitconfig

```bash
gpg --list-secret-keys --keyid-format SHORT
```
