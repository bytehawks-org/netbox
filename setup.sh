#!/bin/bash
# Setup script for NetBox custom image environment

set -e

echo "================================================"
echo "NetBox Custom Image - Environment Setup"
echo "================================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Check if environment files already exist
if [ -f "env/netbox.env" ] && [ -f "env/postgres.env" ] && [ -f "env/redis.env" ] && [ -f "env/redis-cache.env" ]; then
    echo "⚠️  Environment files already exist!"
    read -p "Do you want to overwrite them? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Keeping existing environment files."
        exit 0
    fi
fi

echo "Creating environment files from examples..."

# Copy example files
cp env/netbox.env.example env/netbox.env
cp env/postgres.env.example env/postgres.env
cp env/redis.env.example env/redis.env
cp env/redis-cache.env.example env/redis-cache.env

# Generate secure random passwords
echo "Generating secure passwords..."

if command -v openssl &> /dev/null; then
    POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
    REDIS_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
    REDIS_CACHE_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
    SECRET_KEY=$(openssl rand -base64 60 | tr -d "=+/" | cut -c1-50)
else
    echo "⚠️  OpenSSL not found. Using basic password generation."
    POSTGRES_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
    REDIS_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
    REDIS_CACHE_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
    SECRET_KEY=$(date +%s | sha256sum | base64 | head -c 50)
fi

# Update environment files with generated passwords (cross-platform compatible)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/CHANGE_ME_POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" env/postgres.env
    sed -i '' "s/CHANGE_ME_POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" env/netbox.env
    sed -i '' "s/CHANGE_ME_REDIS_PASSWORD/$REDIS_PASSWORD/g" env/redis.env
    sed -i '' "s/CHANGE_ME_REDIS_PASSWORD/$REDIS_PASSWORD/g" env/netbox.env
    sed -i '' "s/CHANGE_ME_REDIS_CACHE_PASSWORD/$REDIS_CACHE_PASSWORD/g" env/redis-cache.env
    sed -i '' "s/CHANGE_ME_REDIS_CACHE_PASSWORD/$REDIS_CACHE_PASSWORD/g" env/netbox.env
    sed -i '' "s/CHANGE_ME_SECRET_KEY_MINIMUM_50_CHARACTERS_LONG_RANDOM_STRING/$SECRET_KEY/g" env/netbox.env
else
    # Linux
    sed -i "s/CHANGE_ME_POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" env/postgres.env
    sed -i "s/CHANGE_ME_POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" env/netbox.env
    sed -i "s/CHANGE_ME_REDIS_PASSWORD/$REDIS_PASSWORD/g" env/redis.env
    sed -i "s/CHANGE_ME_REDIS_PASSWORD/$REDIS_PASSWORD/g" env/netbox.env
    sed -i "s/CHANGE_ME_REDIS_CACHE_PASSWORD/$REDIS_CACHE_PASSWORD/g" env/redis-cache.env
    sed -i "s/CHANGE_ME_REDIS_CACHE_PASSWORD/$REDIS_CACHE_PASSWORD/g" env/netbox.env
    sed -i "s/CHANGE_ME_SECRET_KEY_MINIMUM_50_CHARACTERS_LONG_RANDOM_STRING/$SECRET_KEY/g" env/netbox.env
fi

echo "✅ Environment files created with secure passwords"
echo ""
echo "================================================"
echo "Setup Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Review environment files in the env/ directory"
echo "2. Build and start: make setup"
echo "3. Create superuser: make superuser"
echo "4. Access NetBox at http://localhost:8000"
echo ""
echo "For more information, see QUICKSTART.md"
