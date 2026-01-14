# Changelog

All notable changes to this NetBox custom image will be documented in this file.

## [4.4.0] - 2026-01-14

### Added
- Initial release of NetBox custom image based on NetBox 4.4
- Included plugins:
  - netbox-validity v3.4.0 - Configuration compliance and device state validation
  - netbox-inventory v2.4.1 - Hardware inventory management
  - netbox-plugin-auth-saml2 v3.0 - SAML2 SSO authentication
  - netbox-lifecycle v1.1.3 - Hardware EOL/EOS, licenses, and contracts
  - netbox-lists v4.0.3 - IP & prefix list generation
  - netbox-documents v0.7.4 - Document management
  - netbox-data-flows v1.4.1 - Data flow documentation
  - netbox-attachments v9.0.1 - File attachments for any model
  - netbox-qrcode v0.0.19 - QR code generation
  - netbox-floorplan-plugin v0.8.0 - Floorplan modeling
  - netbox-bgp v0.17 - BGP configuration management
  - netbox-topology-views v4.4 - Graphical topology maps
  - slurpit_netbox v1.2.7 - Automatic network discovery
  - nb-service v4.2.0 - ITSM service mapping
- Docker Compose configuration for easy deployment
- Plugin configuration file (configuration/extra.py)
- Comprehensive documentation in README.md
- Makefile for convenient management commands
- Example environment files with placeholders

### Security
- All plugins checked against GitHub Advisory Database - no vulnerabilities found
- .gitignore configured to prevent committing sensitive environment files
