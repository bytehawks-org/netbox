.PHONY: help build up down logs clean restart superuser migrate collectstatic shell backup

# Default target
help:
	@echo "NetBox Custom Image - Available Commands:"
	@echo ""
	@echo "  make build          - Build the custom NetBox Docker image"
	@echo "  make up             - Start all services in detached mode"
	@echo "  make down           - Stop all services"
	@echo "  make logs           - Show logs from all services"
	@echo "  make restart        - Restart all services"
	@echo "  make clean          - Stop services and remove volumes (data loss!)"
	@echo ""
	@echo "  make superuser      - Create a NetBox superuser"
	@echo "  make migrate        - Run database migrations"
	@echo "  make collectstatic  - Collect static files"
	@echo "  make shell          - Open a shell in the NetBox container"
	@echo ""
	@echo "  make backup         - Backup the PostgreSQL database"
	@echo "  make setup          - Initial setup (build, up, migrate, collectstatic)"
	@echo ""

# Build the custom image
build:
	docker build -t netbox-custom:4.4 .

# Start all services
up:
	docker compose up -d

# Stop all services
down:
	docker compose down

# Show logs
logs:
	docker compose logs -f

# Restart services
restart: down up

# Clean everything (WARNING: removes volumes)
clean:
	docker compose down -v
	@echo "WARNING: All data has been removed!"

# Create superuser
superuser:
	docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser

# Run migrations
migrate:
	docker compose exec netbox /opt/netbox/netbox/manage.py migrate

# Collect static files
collectstatic:
	docker compose exec netbox /opt/netbox/netbox/manage.py collectstatic --no-input

# Open shell in NetBox container
shell:
	docker compose exec netbox /bin/bash

# Backup database
backup:
	@echo "Creating database backup..."
	@mkdir -p backups
	@docker compose exec postgres pg_dump -U netbox netbox > backups/netbox_backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Backup created in backups/ directory"

# Initial setup
setup: build up
	@echo "Waiting for services to start..."
	@sleep 10
	@make migrate
	@make collectstatic
	@echo ""
	@echo "Setup complete! Next steps:"
	@echo "1. Create a superuser: make superuser"
	@echo "2. Access NetBox at: http://localhost:8000"
	@echo ""
