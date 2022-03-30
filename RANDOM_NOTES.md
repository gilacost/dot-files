## GPG

1.  generate new gpg key

```bash
gpg --full-generate-key
```

2.  show id for previous export, the id is after the '/'

```bash
 gpg --list-secret-keys --keyid-format LONG
```

3.  export public key

```bash
 gpg --armor --export REPLACE_WITH_EXTRACTED_ID
```

4.  display id short version for gitconfig

```bash
gpg --list-secret-keys --keyid-format SHORT
```

nix build ~/.config/darwin\#darwinConfigurations.Pepos-MacBooks.system
./result/sw/bin/darwin-rebuild switch --flake ~/.config/darwin

leerme nix.dev for sure
https://apple.stackexchange.com/questions/335400/how-switch-mac-uk-pc-keyboard-layout-backslash-and-backtick-to-match-normal
todo, when flakes, bring node and split node packages

- nix flake update ./
- nix build ./\#darwinConfigurations.Joseps-MBP.system
- ./result/sw/bin/darwin-rebuild switch --flake ./
- swish review window management

NOTES ALL keystrokes for lsp and config
sudo scutil --set HostName lair

ulti-user Nix users on macOS can upgrade Nix by running: sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'
