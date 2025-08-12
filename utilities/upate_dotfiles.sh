#!/bin/sh

set -e

echo "=== Updating Nix dot-files ==="

# Update Nix channels
echo "Updating Nix channels..."
nix-channel --update

# Update nix and cacert
echo "Updating nix and cacert..."
nix-env -iA nixpkgs.nix nixpkgs.cacert

# Restart nix-daemon
echo "Restarting nix-daemon..."
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon

# Update flake inputs
echo "Updating flake inputs..."
cd "$(dirname "$0")/.."
nix flake update

# Build the updated configuration
echo "Building updated configuration..."
rebuild_nix buque

echo "=== Update complete! ==="
echo "Review changes with: git diff"
echo "Test your configuration and commit changes if everything works correctly."
