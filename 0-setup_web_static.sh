#!/usr/bin/env bash
# This script sets up web servers for the deployment of web_static.

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test
sudo mkdir -p /data/web_static/shared

# Create a fake HTML file
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create symbolic link
sudo ln -sf /data/web_static/releases/test /data/web_static/current

# Give ownership to the ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
nginx_config="location /hbnb_static/ {
    alias /data/web_static/current/;
    index index.html index.htm;
}"

# Add the Nginx configuration if not present
if ! sudo grep -q "location /hbnb_static/" "$config_file"; then
    # Find the server block and add the location block after it
    sudo sed -i '/server {/a \\n'"$nginx_config" "$config_file"
fi

# Restart Nginx
sudo service nginx restart

exit 0
