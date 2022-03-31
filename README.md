# My dot-files

![https://builtwithnix.org](https://img.shields.io/badge/Built_With-Nix-5277C3.svg?logo=nixos&labelColor=73C3D5)

OSX configurations, expressed in [Nix](https://nixos.org/nix)

## Installation requirements

There are three requirements to be able to apply this setup:

- homebrew
- xcode developer tools
- nix
- being logged into the app store

Generate a ssh key and add it to [github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

```bash
ssh-keygen -t rsa -b 4096 -N '' -C "EMAIL"
```

## Installing homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off
```

[official docs](https://brew.sh)

## Installing xcode developer tools

You need git to pull this repository if you open a terminal and type `git` then
a prompt will appear asking you to install xcode developer tools.

## Install nix

Install nix using the interactive script that they provide for multi-user
installation.

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

[official docs](https://nixos.org/download.html)

## Install

Before running the install script set the hostname to one list in the `flake.nix`.

```bash
sudo scutil --set HostName lair
./install.sh
```

- reboot
- set the keyboard to British PC
- press `FN` + `ESC`
- import GPG keys
- log into password manager
- log into spotify
- nvim tree-sitter install all

## Varmilo keyboard

- `FN` + `a` for about 3 seconds until `capslock` flashes and keyboard will swap to `mac` mode.
- `FN` + `w` for about 3 seconds until `capslock` flashes and keyboard will swap to `Windows` mode.
- If `capslock` does not flash after pressing any of the previous combinations mentioned above. Keyboard
  should be already in mentioned mode.
- `FN` + `ESC` for about 3 seconds until `capslock` flashes and keyboard will be reset to defaults.
  rm /Library/Preferences/com.apple.keyboardtype.plist

next steps:

- [ ] emoji shortcut
- [ ] British pc is not in keyboard lists by defaults
- [ ] keyboards do not appear in top bar
- [ ] Bluetooth do not appear in the top bar
- [ ] system preferences in the docker
- [ ] battery percentage are not in the top bar
- [ ] waka apy key is not populated automatically
- [ ] touch zsh_local

- [ ] kubctl zsh completions
- [ ] compe and lsp trouble
- [ ] lua language server
- [ ] hadolint
- [ ] kubernetes YAML schemas investigate
- [ ] firefox vimium and firefox profiles
- [ ] review unverified
- [ ] review all alias
- [ ] youtube dl
- [ ] vim-vsnip installation and bring nice snippets
- [ ] review all maps MAKE A TODO and LIST THEM SOME WHERE PRINTABLE
- [ ] hadolint somewhere (pre-commit docker?)
- [ ] keyboard language? enable and uk? things about other defaults
- [ ] review all vim plugins
- [ ] review all confs with alvivi's and tidy owns
- [ ] hacer list y tal mas fugitive and co
- [ ] key rotation
