#!/bin/bash
# ------------------------------------------------------------
# user_data.sh
# Bootstraps the EC2 instance to host WordPress at:
#   http://<public-ip>/blog
#
# Notes:
# - This installs Apache + PHP
# - Downloads WordPress into /var/www/html/blog
# - This gets the installer page visible.
# - DB wiring (wp-config.php) can be done after RDS is created.
# ------------------------------------------------------------

set -e

yum update -y

# Install Apache
yum install -y httpd
systemctl enable httpd
systemctl start httpd

# Install PHP and common extensions for WordPress
amazon-linux-extras enable php8.0
yum clean metadata
yum install -y php php-mysqlnd php-gd php-xml php-mbstring php-json php-zip unzip

# Download and unpack WordPress into /blog
cd /tmp
curl -L -o wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf wordpress.tar.gz

mkdir -p /var/www/html/blog
cp -r wordpress/* /var/www/html/blog/

# Fix permissions so Apache can serve files
chown -R apache:apache /var/www/html/blog
chmod -R 755 /var/www/html/blog

# Restart Apache to ensure PHP module is loaded
systemctl restart httpd
