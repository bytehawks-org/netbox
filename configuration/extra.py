# NetBox Plugin Configuration
# This file should be mounted to /etc/netbox/config/extra.py in the container

# Enable all installed plugins
PLUGINS = [
    'netbox_validity',
    'netbox_inventory',
    'netbox_plugin_auth_saml2',
    'netbox_lifecycle',
    'netbox_lists',
    'netbox_documents',
    'netbox_data_flows',
    'netbox_attachments',
    'netbox_qrcode',
    'netbox_floorplan',
    'netbox_bgp',
    'netbox_topology_views',
    'slurpit_netbox',
    'nb_service',
]

# Plugin-specific configuration
PLUGINS_CONFIG = {
    'netbox_topology_views': {
        'static_image_directory': 'netbox_topology_views/img',
        'allow_coordinates_saving': True,
    },
    'nb_service': {
        'top_level_menu': True,
    },
    # Add other plugin-specific configurations as needed
}
