#!/bin/bash

set -eufo pipefail

OWNER=$1
REPO=$2
BRANCH=$3

REV=$(curl "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH" | jq -r '.commit.sha')


echo $REV
SHA256=$(nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$REV.tar.gz")
echo $SHA256 

SHA256=$(nix-prefetch-url --unpack "https://github.com/hashicorp/terraform/archive/refs/tags/v1.0.9.tar.gz")

echo $SHA256 
