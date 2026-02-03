#!/usr/bin/env bash

# Script to check for latest versions of dev shells and suggest updates
# This helps maintain up-to-date development environments

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔍 Checking for latest versions of development tools..."
echo ""

# Function to check Elixir versions
check_elixir_versions() {
    echo "📦 Elixir Versions"
    echo "Current latest in dotfiles:"
    cd "$DOTFILES_ROOT"
    grep -E "elixir.*erlang.*=" dev_shells/default.nix | grep -Eo "elixir_[0-9_]+_erlang_[0-9_]+" | sort -V | tail -1
    
    echo ""
    echo "To check latest Elixir version, visit: https://github.com/elixir-lang/elixir/releases"
    echo "To check latest Erlang version, visit: https://github.com/erlang/otp/releases"
    echo ""
}

# Function to check Terraform versions
check_terraform_versions() {
    echo "🏗️  Terraform Versions"
    echo "Current latest in dotfiles:"
    cd "$DOTFILES_ROOT"
    grep -E "terraform_[0-9_]+.*=" dev_shells/default.nix | grep -Eo "terraform_[0-9_]+" | sort -V | tail -1
    
    echo ""
    echo "To check latest Terraform version, visit: https://github.com/hashicorp/terraform/releases"
    echo ""
}

# Function to check Redis versions
check_redis_versions() {
    echo "🔴 Redis Versions"
    echo "Current latest in dotfiles:"
    cd "$DOTFILES_ROOT"
    grep -E "redis_[0-9_]+.*=" dev_shells/default.nix | grep -Eo "redis_[0-9_]+" | sort -V | tail -1
    
    echo ""
    echo "To check latest Redis version, visit: https://github.com/redis/redis/releases"
    echo ""
}

# Function to check OpenTofu versions
check_opentofu_versions() {
    echo "🌐 OpenTofu Versions"
    echo "Current latest in dotfiles:"
    cd "$DOTFILES_ROOT"
    grep -E "opentofu_[0-9_]+.*=" dev_shells/default.nix | grep -Eo "opentofu_[0-9_]+" | sort -V | tail -1
    
    echo ""
    echo "To check latest OpenTofu version, visit: https://github.com/opentofu/opentofu/releases"
    echo ""
}

# Function to list all current dev shells
list_all_shells() {
    echo "📋 All Available Dev Shells"
    cd "$DOTFILES_ROOT"
    nix flake show --json 2>/dev/null | jq -r '
        .devShells."x86_64-darwin" // .devShells."aarch64-darwin" | 
        keys[] | 
        select(. != "default")
    ' | sort -V || echo "Could not list shells (nix not available?)"
    echo ""
}

# Function to suggest updates
suggest_updates() {
    echo "💡 Suggestions for keeping shells updated:"
    echo ""
    echo "1. To add a new Elixir version:"
    echo "   - Find the latest release at https://github.com/elixir-lang/elixir/releases"
    echo "   - Get the SHA256: nix-prefetch-url --type sha256 --unpack https://github.com/elixir-lang/elixir/archive/refs/tags/v<VERSION>.zip"
    echo "   - Add entry to dev_shells/default.nix following existing pattern"
    echo ""
    echo "2. To add a new Terraform version:"
    echo "   - Find the latest release at https://github.com/hashicorp/terraform/releases"
    echo "   - Add entry to dev_shells/default.nix following existing pattern"
    echo ""
    echo "3. To update the 'latest' aliases:"
    echo "   - Update elixir_latest_erlang_latest to point to newest versions"
    echo "   - Update redis_latest to point to newest version"
    echo ""
}

# Main execution
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Development Shells Version Check                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

check_elixir_versions
check_terraform_versions
check_redis_versions
check_opentofu_versions
list_all_shells
suggest_updates

echo "✅ Version check complete!"
echo ""
echo "To use a specific shell in your project:"
echo "  ./utilities/set_dev_shell.sh --latest elixir"
echo "  ./utilities/set_dev_shell.sh --list"
