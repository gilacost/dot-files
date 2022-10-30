#!/bin/sh

nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert; sudo launchctl stop org.nixos.nix-daemon; sudo launchctl start org.nixos.nix-daemon;
