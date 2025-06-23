#!/bin/sh

set -e

echo "=== Updating Nix dot-files ==="

# Go to flake root
cd "$(git rev-parse --show-toplevel)"

# Update flake inputs
echo "Updating flake inputs..."
nix flake update

# Restart nix-daemon (macOS specific)
echo "Restarting nix-daemon..."
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon

# Build the updated configuration
if command -v rebuild_nix >/dev/null 2>&1; then
  echo "Building updated configuration..."
  rebuild_nix buque
else
  echo "Missing 'rebuild_nix' command. Please run your rebuild manually."
fi

echo "=== Update complete! ==="
echo "Review changes with: git diff"
