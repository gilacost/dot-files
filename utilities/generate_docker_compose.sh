#!/bin/bash

# Script to generate docker-compose.yml from commented lines in .tool-versions
# Usage: ./generate_docker_compose.sh

set -e

# Check if .tool-versions exists in current directory
if [ ! -f ".tool-versions" ]; then
    echo "❌ No .tool-versions file found in current directory"
    exit 1
fi

echo "🐳 Generating docker-compose.yml from commented .tool-versions..."

# Start docker-compose file
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
EOF

# Read .tool-versions and process commented lines
while IFS= read -r line; do
    # Only process lines that start with # and contain version info
    if [[ "$line" =~ ^[[:space:]]*#[[:space:]]*([a-zA-Z]+)[[:space:]]+([0-9]+\.[0-9]+(\.[0-9]+)*) ]]; then
        tool="${BASH_REMATCH[1]}"
        version="${BASH_REMATCH[2]}"
        
        case "$tool" in
            postgres|postgresql)
                echo "  postgres:" >> docker-compose.yml
                echo "    image: postgres:${version}" >> docker-compose.yml
                echo "    environment:" >> docker-compose.yml
                echo "      POSTGRES_DB: dev" >> docker-compose.yml
                echo "      POSTGRES_USER: postgres" >> docker-compose.yml
                echo "      POSTGRES_PASSWORD: postgres" >> docker-compose.yml
                echo "    ports:" >> docker-compose.yml
                echo "      - \"5432:5432\"" >> docker-compose.yml
                echo "    volumes:" >> docker-compose.yml
                echo "      - postgres_data:/var/lib/postgresql/data" >> docker-compose.yml
                echo "" >> docker-compose.yml
                echo "✅ Added PostgreSQL ${version}"
                ;;
            redis)
                echo "  redis:" >> docker-compose.yml
                echo "    image: redis:${version}" >> docker-compose.yml
                echo "    ports:" >> docker-compose.yml
                echo "      - \"6379:6379\"" >> docker-compose.yml
                echo "    volumes:" >> docker-compose.yml
                echo "      - redis_data:/data" >> docker-compose.yml
                echo "" >> docker-compose.yml
                echo "✅ Added Redis ${version}"
                ;;
            *)
                echo "⚠️  Unknown service: $tool $version (skipping)"
                ;;
        esac
    fi
done < ".tool-versions"

# Add volumes section if we have any services
if grep -q "postgres_data\|redis_data" docker-compose.yml 2>/dev/null; then
    echo "volumes:" >> docker-compose.yml
    if grep -q "postgres_data" docker-compose.yml; then
        echo "  postgres_data:" >> docker-compose.yml
    fi
    if grep -q "redis_data" docker-compose.yml; then
        echo "  redis_data:" >> docker-compose.yml
    fi
fi

echo ""
echo "🐳 docker-compose.yml generated successfully!"
echo "💡 Run 'docker-compose up -d' to start services"
echo "💡 Run 'docker-compose down' to stop services"