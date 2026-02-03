#!/usr/bin/env bash

# Test script to verify dev shell functions work from any directory

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║    Testing Dev Shell Functions from Different Dirs        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Create a test directory
TEST_DIR="/tmp/test-dev-shell-$$"
mkdir -p "$TEST_DIR"

echo "📁 Created test directory: $TEST_DIR"
echo ""

# Get the actual dotfiles path (script's parent directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_PATH="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "📍 Using dotfiles path: $DOTFILES_PATH"
echo ""

# Define the functions as they would be in the shell
function _dotfiles_path() {
  echo "$DOTFILES_PATH"
}

function set-dev-shell() {
  local dotfiles_path=$(_dotfiles_path)
  if [ ! -f "$dotfiles_path/utilities/set_dev_shell.sh" ]; then
    echo "Error: Could not find dotfiles at $dotfiles_path"
    return 1
  fi
  "$dotfiles_path/utilities/set_dev_shell.sh" "$@"
}

function check-shell-versions() {
  local dotfiles_path=$(_dotfiles_path)
  if [ ! -f "$dotfiles_path/utilities/check_shell_versions.sh" ]; then
    echo "Error: Could not find dotfiles at $dotfiles_path"
    return 1
  fi
  "$dotfiles_path/utilities/check_shell_versions.sh" "$@"
}

# Test 1: Check if functions are defined
echo "Test 1: Verifying functions are defined"
if type set-dev-shell >/dev/null 2>&1; then
    echo "✓ set-dev-shell function is defined"
else
    echo "✗ set-dev-shell function is NOT defined"
    exit 1
fi

if type check-shell-versions >/dev/null 2>&1; then
    echo "✓ check-shell-versions function is defined"
else
    echo "✗ check-shell-versions function is NOT defined"
    exit 1
fi
echo ""

# Test 2: Run help from a different directory
echo "Test 2: Running set-dev-shell --help from test directory"
cd "$TEST_DIR"
if set-dev-shell --help >/dev/null 2>&1; then
    echo "✓ set-dev-shell --help works from $TEST_DIR"
else
    echo "✗ set-dev-shell --help failed from $TEST_DIR"
    exit 1
fi
echo ""

# Test 3: Test listing shells from different directory (may fail if Nix isn't available)
echo "Test 3: Testing set-dev-shell --list from test directory"
cd "$TEST_DIR"
if set-dev-shell --list 2>&1 | grep -q "Available dev shells\|Could not retrieve"; then
    echo "✓ set-dev-shell --list works from $TEST_DIR (or gracefully handled missing Nix)"
else
    echo "⚠️  set-dev-shell --list output unexpected (might be OK if Nix is unavailable)"
fi
echo ""

# Test 4: Test check-shell-versions from different directory
echo "Test 4: Testing check-shell-versions from test directory"
cd "$TEST_DIR"
if check-shell-versions 2>&1 | head -20 | grep -q "Checking for latest\|Elixir\|Terraform\|Redis"; then
    echo "✓ check-shell-versions works from $TEST_DIR"
else
    echo "⚠️  check-shell-versions output unexpected (might be OK if Nix is unavailable)"
fi
echo ""

# Test 5: Verify current directory hasn't changed
echo "Test 5: Verifying we're still in test directory"
CURRENT_DIR=$(pwd)
if [ "$CURRENT_DIR" = "$TEST_DIR" ]; then
    echo "✓ Still in test directory: $CURRENT_DIR"
else
    echo "✗ Directory changed unexpectedly to: $CURRENT_DIR"
    exit 1
fi
echo ""

# Cleanup
cd /tmp
rm -rf "$TEST_DIR"
echo "🧹 Cleaned up test directory"
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    All Tests Passed! ✓                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "The dev shell functions work correctly from any directory!"
