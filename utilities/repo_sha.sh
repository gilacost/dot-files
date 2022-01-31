#!/bin/bash

set -eufo pipefail

OWNER=$1
REPO=$2
BRANCH=$3

REV=$(curl "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH" | jq -r '.commit.sha')


echo $REV
SHA256=$(nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$REV.tar.gz")
echo $SHA256 

# SHA256=$(nix-prefetch-url --unpack "https://github.com/hashicorp/terraform/archive/refs/tags/v1.0.9.tar.gz")

# echo $SHA256 

# ERLSHA=$(nix-prefetch-url --unpack "https://github.com/erlang/otp/archive/refs/tags/OTP-24.2.tar.gz")

# echo $ERLSHA

# REBARSHA=$(nix-prefetch-url --unpack "https://github.com/erlang/rebar3/archive/refs/tags/3.18.0.tar.gz")

# echo $REBARSHA

# EXSHA=$(nix-prefetch-url --unpack "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.13.2.tar.gz")

# echo $EXSHA
nix flake lock --update-input nixpkgs
