#!/bin/bash

# nix flake update

darwin-rebuild build --flake ./\#$HOSTNAME
darwin-rebuild switch --flake ./\#$HOSTNAME
