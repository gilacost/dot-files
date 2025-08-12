#!/bin/bash

# Script to install asdf plugins from .tool-versions file
# Usage: ./install_asdf_plugins.sh
# Skips lines that are commented out with #

set -e

# Check if .tool-versions exists in current directory
if [ ! -f ".tool-versions" ]; then
    echo "❌ No .tool-versions file found in current directory"
    exit 1
fi

echo "📦 Installing asdf plugins from .tool-versions..."

# Read .tool-versions and install plugins
while IFS= read -r line; do
    # Skip empty lines and lines that start with # (commented out)
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        echo "⏭️  Skipping: $line"
        continue
    fi
    
    # Extract plugin name (first word)
    plugin=$(echo "$line" | awk '{print $1}')
    
    if [ -n "$plugin" ]; then
        echo "Installing plugin: $plugin"
        if asdf plugin add "$plugin" 2>/dev/null; then
            echo "✅ Plugin $plugin installed successfully"
        else
            echo "⚠️  Plugin $plugin already installed or failed to install"
        fi
    fi
done < ".tool-versions"

echo ""
echo "✅ Plugin installation complete!"
echo "💡 Now run 'asdf install' to install the versions specified in .tool-versions"