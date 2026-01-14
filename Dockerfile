# NetBox Custom Image with Plugins
# Based on NetBox 4.4
FROM netboxcommunity/netbox:v4.4

# Copy plugin requirements
COPY plugin_requirements.txt /

# Install plugins into NetBox's virtual environment
RUN /opt/netbox/venv/bin/pip install --no-warn-script-location -r /plugin_requirements.txt
