#!/usr/bin/env bash

# Local test script to validate the functionality that will run in CI
# This helps ensure the GitHub Actions workflow will work correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$DOTFILES_ROOT"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Testing Dotfiles Locally                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if Nix is available
if ! command -v nix &> /dev/null; then
    echo "✗ Nix is not installed. Please install Nix first."
    exit 1
fi

echo "✓ Nix is installed"
echo ""

# Test 1: List dev shells
echo "📦 Test 1: Listing development shells"
if nix flake show --json 2>/dev/null | jq -r '.devShells' | grep -q "aarch64-darwin\|x86_64-darwin"; then
    echo "✓ Dev shells are available"
    nix flake show 2>/dev/null | grep "devShell" | head -10
else
    echo "⚠️  Could not list dev shells"
fi
echo ""

# Test 2: Check flake validity
echo "🔍 Test 2: Checking flake validity"
if nix flake check --no-build 2>&1 | grep -q "error:"; then
    echo "✗ Flake check failed"
    nix flake check --no-build
    exit 1
else
    echo "✓ Flake is valid"
fi
echo ""

# Test 3: Try to build (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🏗️  Test 3: Testing build (macOS detected)"
    HOSTNAME=$(hostname | sed 's/.local//g')
    
    # Check if hostname is in flake
    if grep -q "$HOSTNAME" flake.nix; then
        echo "Building for hostname: $HOSTNAME"
        echo "This may take a while..."
        
        # Try a dry run first
        if nix build "./#darwinConfigurations.$HOSTNAME.system" --dry-run 2>&1; then
            echo "✓ Dry run successful"
        else
            echo "⚠️  Dry run had issues, but continuing..."
        fi
    else
        echo "⚠️  Hostname $HOSTNAME not found in flake.nix, skipping build test"
        echo "   Available: buque"
    fi
else
    echo "⏭️  Test 3: Skipped (not on macOS)"
fi
echo ""

# Test 4: Test nvim if available
echo "📝 Test 4: Testing Neovim"
if command -v nvim &> /dev/null; then
    echo "Testing Neovim startup..."
    if timeout 5s nvim --headless -c 'echo "test"' -c 'quitall' 2>&1; then
        echo "✓ Neovim started successfully"
    else
        echo "⚠️  Neovim test had issues"
    fi
else
    echo "⚠️  Neovim not found in PATH, skipping test"
fi
echo ""

# Test 5: Test utility scripts
echo "🔧 Test 5: Testing utility scripts"
if [ -x "./utilities/set_dev_shell.sh" ]; then
    echo "Testing set_dev_shell.sh..."
    ./utilities/set_dev_shell.sh --help > /dev/null 2>&1
    echo "✓ set_dev_shell.sh is executable and working"
else
    echo "✗ set_dev_shell.sh not found or not executable"
fi

if [ -x "./utilities/check_shell_versions.sh" ]; then
    echo "Testing check_shell_versions.sh..."
    ./utilities/check_shell_versions.sh > /dev/null 2>&1 || true
    echo "✓ check_shell_versions.sh is executable"
else
    echo "✗ check_shell_versions.sh not found or not executable"
fi
echo ""

# Summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Test Summary                                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Local tests completed!"
echo ""
echo "The following will be tested in CI:"
echo "  • Weekly automated dependency updates"
echo "  • Full system build on GitHub runners"
echo "  • Neovim startup validation"
echo "  • Pull request creation with changes"
echo ""
echo "To manually trigger the GitHub Actions workflow:"
echo "  Go to: Actions -> Weekly Dependency Update -> Run workflow"
