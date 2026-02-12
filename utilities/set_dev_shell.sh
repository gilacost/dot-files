#!/usr/bin/env bash

# Script to set up a development shell in .envrc for the current directory
# Usage: ./utilities/set_dev_shell.sh [shell_name]
#        ./utilities/set_dev_shell.sh --list
#        ./utilities/set_dev_shell.sh --latest elixir
#        ./utilities/set_dev_shell.sh --latest terraform

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Detect system architecture for dev shells
get_system_arch() {
    case "$(uname -m)" in
        arm64|aarch64) echo "aarch64-darwin" ;;
        x86_64) echo "x86_64-darwin" ;;
        *) echo "x86_64-darwin" ;;  # Default fallback
    esac
}

SYSTEM_ARCH=$(get_system_arch)

# Function to list available dev shells
list_shells() {
    echo "🔍 Available dev shells:"
    cd "$DOTFILES_ROOT"
    nix flake show --json 2>/dev/null | jq -r '
        .devShells."'"$SYSTEM_ARCH"'" |
        keys[] |
        select(. != "default")
    ' | sort || {
        echo "Error: Could not retrieve dev shells. Make sure you're in the dotfiles directory."
        exit 1
    }
}

# Function to get the latest version of a specific shell type
get_latest_shell() {
    local shell_type="$1"
    cd "$DOTFILES_ROOT"

    # Get all shells matching the type and sort to get the latest
    local latest=$(nix flake show --json 2>/dev/null | jq -r '
        .devShells."'"$SYSTEM_ARCH"'" |
        keys[] |
        select(startswith("'$shell_type'"))
    ' | sort -V | tail -1)

    if [ -z "$latest" ]; then
        echo "Error: No shells found matching '$shell_type'"
        exit 1
    fi

    echo "$latest"
}

# Function to write shell to .envrc
write_envrc() {
    local shell_name="$1"
    local use_local="${2:-false}"

    # Verify the shell exists
    cd "$DOTFILES_ROOT"
    if ! nix flake show --json 2>/dev/null | jq -e '.devShells."'"$SYSTEM_ARCH"'"."'$shell_name'"' > /dev/null; then
        echo "Error: Shell '$shell_name' not found"
        echo "Run with --list to see available shells"
        exit 1
    fi

    # Determine the flake reference
    local flake_ref
    if [ "$use_local" = "true" ]; then
        flake_ref="$DOTFILES_ROOT#$shell_name"
    else
        flake_ref="github:gilacost/dot-files#$shell_name"
    fi

    # Create or update .envrc
    if [ -f ".envrc" ]; then
        echo "⚠️  .envrc already exists. Creating backup as .envrc.backup"
        cp .envrc .envrc.backup
    fi

    echo "use flake $flake_ref" > .envrc

    echo "✅ Created .envrc with: use flake $flake_ref"
    echo ""
    echo "Next steps:"
    echo "  1. Run: direnv allow"
    echo "  2. The dev shell will load automatically when you cd into this directory"
}

# Main script
case "${1:-}" in
    --list|-l)
        list_shells
        ;;
    --latest)
        if [ -z "${2:-}" ]; then
            echo "Error: --latest requires a shell type (e.g., elixir, terraform, redis)"
            echo "Usage: $0 --latest <shell_type>"
            exit 1
        fi
        shell_name=$(get_latest_shell "$2")
        echo "Latest $2 shell: $shell_name"
        
        # Ask if user wants to write to .envrc
        read -p "Write this to .envrc in current directory? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Use local path or GitHub reference? (l/g) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Ll]$ ]]; then
                write_envrc "$shell_name" true
            else
                write_envrc "$shell_name" false
            fi
        fi
        ;;
    --help|-h|"")
        echo "Usage: $0 [OPTIONS] [SHELL_NAME]"
        echo ""
        echo "Set up a Nix development shell in .envrc for the current directory"
        echo ""
        echo "Options:"
        echo "  --list, -l              List all available dev shells"
        echo "  --latest <type>         Get and optionally set the latest shell of a type"
        echo "                          (e.g., elixir, terraform, redis)"
        echo "  --help, -h              Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 --list"
        echo "  $0 --latest elixir"
        echo "  $0 elixir_1_18_1_erlang_27_2"
        echo ""
        echo "If SHELL_NAME is provided, it will be written to .envrc"
        ;;
    *)
        # Shell name provided directly
        shell_name="$1"
        echo "Setting up dev shell: $shell_name"
        read -p "Use local path or GitHub reference? (l/g) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ll]$ ]]; then
            write_envrc "$shell_name" true
        else
            write_envrc "$shell_name" false
        fi
        ;;
esac
