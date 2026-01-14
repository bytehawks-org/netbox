# NetBox Custom Image with Plugins

A custom NetBox Docker image based on release 4.4 with pre-installed plugins for enhanced functionality.

## Included Plugins

This custom image includes the following plugins:

| Plugin | Version | Description |
|--------|---------|-------------|
| netbox-validity | 3.4.0 | Configuration compliance and device state validation |
| netbox-inventory | 2.4.1 | Hardware inventory management |
| netbox-plugin-auth-saml2 | 3.0 | SAML2 SSO authentication |
| netbox-lifecycle | 1.1.3 | Hardware EOL/EOS, licenses, and contracts |
| netbox-lists | 4.0.3 | IP & prefix list generation |
| netbox-documents | 0.7.4 | Document management |
| netbox-data-flows | 1.4.1 | Data flow documentation |
| netbox-attachments | 9.0.1 | File attachments for any model |
| netbox-qrcode | 0.0.19 | QR code generation |
| netbox-floorplan-plugin | 0.8.0 | Floorplan modeling |
| netbox-bgp | 0.17 | BGP configuration management |
| netbox-topology-views | 4.4 | Graphical topology maps |
| slurpit_netbox | 1.2.7 | Automatic network discovery |
| nb-service | 4.2.0 | ITSM service mapping |

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+

## Quick Start

**For detailed step-by-step instructions, see [QUICKSTART.md](QUICKSTART.md)**

### Automated Setup (Recommended)

```bash
git clone https://github.com/bytehawks-org/netbox.git
cd netbox
./setup.sh        # Configure environment with secure passwords
make setup        # Build and start NetBox
make superuser    # Create admin account
```

Then access NetBox at http://localhost:8000

### Manual Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/bytehawks-org/netbox.git
   cd netbox
   ```

2. **Configure environment variables:**
   ```bash
   cp env/*.env.example env/
   # Edit env/*.env files and replace CHANGE_ME_* placeholders
   ```

3. **Build and start:**
   ```bash
   make setup
   # Or: docker build -t netbox-custom:4.4 . && docker compose up -d
   ```

4. **Initialize:**
   ```bash
   make migrate
   make collectstatic
   make superuser
   ```

5. **Access NetBox:**
   Open your browser and navigate to http://localhost:8000

## Configuration

### Plugin Configuration

Plugin configuration is managed in `configuration/extra.py`. This file is mounted as a volume and read by NetBox at startup.

To enable/disable plugins, edit the `PLUGINS` list in `configuration/extra.py`:

```python
PLUGINS = [
    'netbox_validity',
    'netbox_inventory',
    # ... other plugins
]
```

### Plugin-Specific Settings

Plugin-specific settings can be configured in the `PLUGINS_CONFIG` dictionary in `configuration/extra.py`:

```python
PLUGINS_CONFIG = {
    'netbox_topology_views': {
        'static_image_directory': 'netbox_topology_views/img',
        'allow_coordinates_saving': True,
    },
    'nb_service': {
        'top_level_menu': True,
    },
}
```

### Environment Variables

Environment variables are stored in the `env/` directory:

- `env/netbox.env` - NetBox application settings
- `env/postgres.env` - PostgreSQL database settings
- `env/redis.env` - Redis queue settings
- `env/redis-cache.env` - Redis cache settings

**Important:** Change the default passwords in these files before deploying to production!

## Customization

### Adding More Plugins

To add additional plugins:

1. Add the plugin package to `plugin_requirements.txt`:
   ```
   netbox-your-plugin==1.0.0
   ```

2. Enable the plugin in `configuration/extra.py`:
   ```python
   PLUGINS = [
       # ... existing plugins
       'netbox_your_plugin',
   ]
   ```

3. Rebuild the Docker image:
   ```bash
   docker build -t netbox-custom:4.4 .
   ```

4. Restart the services:
   ```bash
   docker compose down
   docker compose up -d
   ```

5. Run migrations:
   ```bash
   docker compose exec netbox /opt/netbox/netbox/manage.py migrate
   ```

### Updating Plugin Versions

1. Update the version in `plugin_requirements.txt`
2. Rebuild the image and restart services as shown above
3. Run any necessary migrations

## Maintenance

### Backup

It's recommended to regularly backup the PostgreSQL database:

```bash
docker compose exec postgres pg_dump -U netbox netbox > netbox_backup_$(date +%Y%m%d).sql
```

### Logs

View logs for troubleshooting:

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f netbox
```

### Updating NetBox

To update to a newer NetBox version:

1. Update the base image version in `Dockerfile`
2. Check plugin compatibility with the new NetBox version
3. Update plugin versions in `plugin_requirements.txt` as needed
4. Rebuild and restart

## Troubleshooting

### Plugins Not Appearing

1. Verify the plugin is listed in `PLUGINS` in `configuration/extra.py`
2. Check that migrations have been run: `docker compose exec netbox /opt/netbox/netbox/manage.py migrate`
3. Verify static files are collected: `docker compose exec netbox /opt/netbox/netbox/manage.py collectstatic --no-input`
4. Check logs: `docker compose logs netbox`

### Database Connection Issues

Ensure PostgreSQL is healthy:
```bash
docker compose ps postgres
```

### Plugin Installation Errors

Check the build logs:
```bash
docker build -t netbox-custom:4.4 . 2>&1 | tee build.log
```

## Architecture

```
┌─────────────────────────────────────────┐
│         NetBox Web (Port 8000)          │
│    (Custom Image with Plugins)          │
└──────────────┬──────────────────────────┘
               │
    ┌──────────┼──────────┬──────────┐
    │          │          │          │
┌───▼────┐ ┌──▼───┐ ┌────▼───┐ ┌────▼──────┐
│ Worker │ │ House│ │  Redis │ │ PostgreSQL│
│        │ │keeping│ │  Cache │ │   DB      │
└────────┘ └──────┘ └────────┘ └───────────┘
```

## License

This custom image builds upon NetBox Community Edition. Please refer to the [NetBox license](https://github.com/netbox-community/netbox) for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Support

For NetBox-specific issues, refer to the [official NetBox documentation](https://docs.netbox.dev/).

For plugin-specific issues, refer to the individual plugin documentation.

## References

- [NetBox Official Documentation](https://docs.netbox.dev/)
- [NetBox Docker Documentation](https://github.com/netbox-community/netbox-docker)
- [NetBox Plugin Development](https://docs.netbox.dev/en/stable/plugins/)
