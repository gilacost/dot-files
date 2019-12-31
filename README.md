# Dev Environment
This works only in OSX for the time being ;)
Feel free to use. Clone this repo and run `./bootstrap.sh`.

These are my dotfiles.

# Credit

I copied the wole Makefile structure for the installation from
from Fran's dotfiles https://github.com/nciscoj/dot-files.

# Todo

mv to mackup

# Random commands

- generate new gpg key

gpg --default-new-key-algo rsa4096 --gen-key

- list id for previous export, the id is after the '/'

gpg --list-secret-keys --keyid-format LONG

- export public key

gpg --armor --export REPLACE_WITH_EXTRACTED_ID

- display id short version for gitconfig

gpg --list-secret-keys --keyid-format SHORT
