# Quick Start Guide

Get your custom NetBox instance up and running in minutes!

## Prerequisites

- Docker Engine 20.10 or newer
- Docker Compose 2.0 or newer
- At least 4GB of available RAM
- At least 10GB of available disk space

## 5-Minute Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/bytehawks-org/netbox.git
cd netbox
```

### Step 2: Configure Environment Variables

Copy the example environment files and customize them:

```bash
# Copy all example files
cp env/netbox.env.example env/netbox.env
cp env/postgres.env.example env/postgres.env
cp env/redis.env.example env/redis.env
cp env/redis-cache.env.example env/redis-cache.env

# Generate secure passwords (Linux/Mac)
POSTGRES_PASSWORD=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 32)
REDIS_CACHE_PASSWORD=$(openssl rand -base64 32)
SECRET_KEY=$(openssl rand -base64 50)

# Update the environment files with generated passwords
sed -i "s/CHANGE_ME_POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" env/*.env
sed -i "s/CHANGE_ME_REDIS_PASSWORD/$REDIS_PASSWORD/g" env/redis.env
sed -i "s/CHANGE_ME_REDIS_CACHE_PASSWORD/$REDIS_CACHE_PASSWORD/g" env/redis-cache.env
sed -i "s/CHANGE_ME_SECRET_KEY_MINIMUM_50_CHARACTERS_LONG_RANDOM_STRING/$SECRET_KEY/g" env/netbox.env
```

### Step 3: Build and Start

Using Makefile (recommended):

```bash
make setup
```

Or using Docker Compose directly:

```bash
# Build the custom image
docker build -t netbox-custom:4.4 .

# Start all services
docker compose up -d

# Wait for services to initialize (about 30 seconds)
sleep 30

# Run database migrations
docker compose exec netbox /opt/netbox/netbox/manage.py migrate

# Collect static files
docker compose exec netbox /opt/netbox/netbox/manage.py collectstatic --no-input
```

### Step 4: Create Admin User

```bash
make superuser
# Or: docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser
```

Follow the prompts to create your admin account.

### Step 5: Access NetBox

Open your browser and navigate to:

```
http://localhost:8000
```

Login with the superuser credentials you just created!

## What's Included?

Your NetBox instance comes pre-configured with 14 powerful plugins:

✅ **Validity** - Device configuration validation  
✅ **Inventory** - Hardware inventory tracking  
✅ **SAML2 Auth** - Single sign-on integration  
✅ **Lifecycle** - EOL/EOS management  
✅ **Lists** - IP and prefix lists  
✅ **Documents** - Document management  
✅ **Data Flows** - Application data flows  
✅ **Attachments** - File attachments  
✅ **QR Code** - QR code generation  
✅ **Floorplan** - Visual floorplans  
✅ **BGP** - BGP configuration  
✅ **Topology Views** - Network topology  
✅ **Slurp'it** - Network discovery  
✅ **NBService** - Service mapping  

## Common Commands

```bash
# View logs
make logs

# Restart services
make restart

# Open shell in NetBox container
make shell

# Create database backup
make backup

# Stop all services
make down
```

## Troubleshooting

### Services won't start

Check if ports 8000, 5432, or 6379 are already in use:

```bash
lsof -i :8000
lsof -i :5432
lsof -i :6379
```

### Database connection errors

Wait a bit longer for PostgreSQL to initialize:

```bash
docker compose logs postgres
```

### Plugins not showing

Ensure migrations have been run:

```bash
make migrate
make collectstatic
docker compose restart netbox
```

## Next Steps

1. **Configure plugins** - Edit `configuration/extra.py` to customize plugin settings
2. **Add data** - Start adding your network infrastructure
3. **Explore plugins** - Each plugin adds new features in the NetBox UI
4. **Set up backups** - Run `make backup` regularly to backup your database
5. **Read the docs** - Check README.md for detailed documentation

## Getting Help

- **NetBox Documentation**: https://docs.netbox.dev/
- **NetBox Docker**: https://github.com/netbox-community/netbox-docker
- **Plugin Documentation**: See individual plugin GitHub repositories

## Production Deployment

**⚠️ Warning:** This setup uses default passwords and is intended for development/testing.

For production:
1. Use strong, unique passwords in environment files
2. Enable HTTPS/TLS with a reverse proxy (nginx, traefik)
3. Configure proper backups
4. Review and harden security settings
5. Consider using Docker secrets for sensitive data
6. Set up monitoring and logging
7. Review plugin security configurations

Happy networking! 🚀
