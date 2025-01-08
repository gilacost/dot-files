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


[official docs](https://nixos.org/download.html)

## Install

Before running the install script set the hostname to one list in the `flake.nix`.

```bash
export HOSTNAME=buque
./install.sh
```

- reboot
- set the keyboard to British PC
- press `FN` + `ESC`
- import GPG keys
- log into password manager
- log into spotify
- nvim tree-sitter install all

## Starting a nix linux-builder on macos

```bash
nix run 'github:NixOS/nixpkgs/23.05#darwin.builder'
```

if you have issues with port 22 already being allocated you can disable
remote login in your machine with the following command:

```bash
sudo systemsetup -setremotelogin off
```

If you have started already the builder vm and you want to stop it just run
`pkill qemu`.

## Varmilo keyboard

- `FN` + `a` for about 3 seconds until `capslock` flashes and keyboard will swap to `mac` mode.
- `FN` + `w` for about 3 seconds until `capslock` flashes and keyboard will swap to `Windows` mode.
- If `capslock` does not flash after pressing any of the previous combinations mentioned above. Keyboard
  should be already in mentioned mode.
- `FN` + `ESC` for about 3 seconds until `capslock` flashes and keyboard will be reset to defaults.
- https://en.varmilo.com/keyboardproscenium/question
- Hold Fn down and press ESC about 4 seconds, if Capslocked backlight can flash 3 times, it means reset succeed. If FN and left WIN swapped,hold left WIN down, and press ESC about 4 seconds, capslocked backlight will flash 3 times.

<!-- Next steps: -->

<!-- - [x] remove yabai and restore magnet -->
<!-- - [x] all lua -->
<!-- - [ ] secrets into age -->
<!-- - [ ] refactor/modularise -->
<!-- - [ ] disable sip and switch yabai//magnet -->

<!-- TODO: -->

<!-- - [ ] emoji shortcut -->
<!-- - [ ] British pc is not in keyboard lists by defaults -->
<!-- - [ ] keyboards do not appear in top bar -->
<!-- - [ ] Bluetooth do not appear in the top bar -->
<!-- - [ ] system preferences in the docker -->
<!-- - [ ] battery percentage are not in the top bar -->
<!-- - [ ] waka apy key is not populated automatically -->
<!-- - [ ] touch zsh_local -->
<!-- - [ ] kubctl zsh completions -->
<!-- - [ ] compe and lsp trouble -->
<!-- - [ ] lua language server -->
<!-- - [ ] hadolint -->
<!-- - [ ] kubernetes YAML schemas investigate -->
<!-- - [ ] firefox vimium and firefox profiles -->
<!-- - [ ] review unverified -->
<!-- - [ ] review all alias -->
<!-- - [ ] youtube dl -->
<!-- - [ ] vim-vsnip installation and bring nice snippets -->
<!-- - [ ] review all maps MAKE A TODO and LIST THEM SOME WHERE PRINTABLE -->
<!-- - [ ] hadolint somewhere (pre-commit docker?) -->
<!-- - [ ] keyboard language? enable and uk? things about other defaults -->
<!-- - [ ] review all vim plugins -->
<!-- - [ ] review all confs with alvivi's and tidy owns -->
<!-- - [ ] hacer list y tal mas fugitive and co -->
<!-- - [ ] key rotation -->

<!-- Si hay problema con lost sitter parsers rm -rf cd ~/.local/share/site -->

<!-- TODO lua -->
<!-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/ -->
<!-- - [x] git.vim -->
<!-- - [x] init-lua.vim -->
<!-- - [x] init.lua (review) -->
<!-- - [x] lsp.nix -->
<!-- - [x] sets.vim -->
<!-- - [x] terminal.vim -->
<!-- - [x] lspkind.vim -->
<!-- - [x] telescope.vim -->
<!-- - [x] theme.vim -->
<!-- - [x] review buff delete -->
<!-- - [ ] lualine.vim REVIEW -->
<!-- - [ ] mappings.lua -->
<!-- - [ ] projections.vim REVIEW move to -->
<!-- - [ ] rename file -->
<!-- - [ ] cmp, lsp config and lsptrouble review -->

<!-- TODO include the config file in .ssh/ copied from 1password developer settings -->
<!-- killall ssh-agent; eval `ssh-agent` -->

<!-- ## 1password -->

<!-- https://developer.1password.com/docs/cli/shell-plugins/github/ -->

<!-- - eval $(op signin) -->
<!-- - eval $(op signin --account my) -->
<!-- - eval $(op signin --account my.1password.com) -->
<!-- - https://1password.community/discussion/127950/v2-client-unable-to-connect-to-desktop-app -->
<!-- - https://developer.1password.com/docs/cli/get-started/?utm_source=google&utm_medium=cpc&utm_campaign=18646033576&utm_content=&utm_term=&gclid=CjwKCAjw__ihBhADEiwAXEazJkRCGq2GSVzS61dBrVpuQnbHFfWB0YKFWa8epb8LqdCRbmhRuCdkGxoCG_IQAvD_BwE&gclsrc=aw.ds -->
<!-- - https://github.com/NixOS/nixpkgs/issues/222991 -->
