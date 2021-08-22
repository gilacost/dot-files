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

## lang-server
talk about node2nix

nix-env -i -f modules/elixirls.nix --show-trace
node2nix -i <(echo '["vscode-langservers-extracted","dockerfile-language-server-nodejs", "vim-language-server"]')
nix-env -i -f modules/node/default.nix --show-trace

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
* `nix-env -q` list packages installed in env
* `nix-env -e <package>`

next steps:
- read compe docs
- disable linting for ale and restore fixing (prettier, mix format terraform, etc)
- acabar el tour
- review all maps
- hadolint somewhere (pre-commit docker?)
- keyboard language? enable and uk? thinks about other defaults
- review all vim plugins
- review all confs with alvivi's and tidy owns
- yabai
- play with telescope
- hacer list y tal mas fugitive and co
- key rotation
- sort ligatures
- move to flakes
- tailwincss lsp

## SSH

## git-crypt

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
