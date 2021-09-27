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


## Language servers (NPM)

* `node2nix` [LINK TO PACKAGE] has been used to generate a derivations that contains
this node packages:

* `vscode-langservers-extracted`
* `dockerfile-language-server-nodejs`
* `vim-language-server`
* `tailwindcss-language-server`
* `bash-language-server`

By running:

```bash
node2nix -i <(echo '["tailwindcss-language-server", "bash-language-server", "vscode-langservers-extracted" \
,"dockerfile-language-server-nodejs", "vim-language-server", "yaml-language-server"]')
```

And then installing the generated default.nix like this

`nix-env -i -f modules/node/default.nix --show-trace`

## Useful commands

* `nix-shell -p nix-info --run "nix-info -m"`
* `nix-env -q` list packages installed in env
* `nix-env -e <package>`

next steps:
- kubctl zsh completions
- compe and lsp trouble
- lua language server
- hadolint
- kubernetes YAML schemas investigate
- ale for prettier fix
- setup for all stuff of new project
- read kubernetes fd
- deploy current service to kubernetes cluster
- add nur packages and firefox extensions
- firefox vimium and firefox profiles
- vim spell?
- review unverified
- review all alias
- youtube dl
- vim-vsnip installation and bring nice snippets
- review all maps MAKE A TODO and LIST THEM SOME WHERE PRINTABLE
- acabar el tour
- hadolint somewhere (pre-commit docker?)
- keyboard language? enable and uk? things about other defaults
- review all vim plugins
- review all confs with alvivi's and tidy owns
- hacer list y tal mas fugitive and co
- key rotation
- use lua.nix and include elixir ls package
- compare 1password with pass or last pass

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

## Varmilo keyboard

* `FN` + `a` for about 3 seconds until `capslock` flashes and keyboard will swap to `mac` mode.
* `FN` + `w` for about 3 seconds until `capslock` flashes and keyboard will swap to `Windows` mode.
* If `capslock` does not flash after pressing any of the previous combinations mentioned above. Keyboard
should be already in mentioned mode.
* `FN` + `ESC` for about 3 seconds until `capslock` flashes and keyboard will be reset to defaults.
rm /Library/Preferences/com.apple.keyboardtype.plist

nix build ~/.config/darwin\#darwinConfigurations.Pepos-MacBooks.system
./result/sw/bin/darwin-rebuild switch --flake ~/.config/darwin

leerme nix.dev for sure
https://apple.stackexchange.com/questions/335400/how-switch-mac-uk-pc-keyboard-layout-backslash-and-backtick-to-match-normal
