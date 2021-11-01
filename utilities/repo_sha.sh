#!/bin/bash

set -eufo pipefail

FILE=$1
PROJECT=$2
BRANCH=${3:-master}

OWNER=$(jq -r '.[$project].owner' --arg project "$PROJECT" < "$FILE")
REPO=$(jq -r '.[$project].repo' --arg project "$PROJECT" < "$FILE")

# REV=$(curl "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH" | jq -r '.commit.sha')

REV=$(jq -r '.[$project].rev' --arg project "$PROJECT" < "$FILE")

echo $REV
SHA256=$(nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$REV.tar.gz")
echo $SHA256
