#!/bin/bash

# Redirect stderr to a log file
exec 2> installation_errors.log

# Update the system
yum -y update

# Install cPanel
curl -o latest -L https://securedownloads.cpanel.net/latest
chmod +x latest
./latest

# Install LiteSpeed
wget https://www.litespeedtech.com/packages/7.0/lsws-latest-7.0.tgz
tar -zxvf lsws-latest-7.0.tgz
cd lsws-7.0*
./install.sh

# Install CloudLinux
wget https://repo.cloudlinux.com/cloudlinux/sources/cln/cldeploy
sh cldeploy -k YOUR_ACTIVATION_KEY

# Install Imunify360
wget https://repo.imunify360.cloudlinux.com/defence360/imunify360.repo -O /etc/yum.repos.d/imunify360.repo
yum install imunify360-firewall

# Install Let's Encrypt SSL
yum install epel-release
yum install certbot
certbot --apache

# Install JetBackup
wget https://repo.jetlicense.com/jetapps.repo -O /etc/yum.repos.d/jetapps.repo
yum install jetapps-jetbackup

# Install Softaculous
wget -N http://files.softaculous.com/install.sh
chmod 755 install.sh
./install.sh

# Install SitePad
wget -N https://files.sitepad.com/install.sh
chmod 755 install.sh
./install.sh

# Install PHP Alt
wget https://files.cloudlinux.com/phpalt/phpalt-latest.el7.x86_64.rpm
yum install phpalt-latest.el7.x86_64.rpm

# Install Firewall (assuming firewalld)
yum install firewalld
systemctl start firewalld
systemctl enable firewalld

# Open necessary ports in the firewall (adjust as needed)
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent

# Open cPanel ports
firewall-cmd --zone=public --add-port=2082/tcp --permanent
firewall-cmd --zone=public --add-port=2083/tcp --permanent
firewall-cmd --zone=public --add-port=2086/tcp --permanent
firewall-cmd --zone=public --add-port=2087/tcp --permanent
firewall-cmd --zone=public --add-port=2095/tcp --permanent
firewall-cmd --zone=public --add-port=2096/tcp --permanent
firewall-cmd --zone=public --add-port=2077/tcp --permanent

# Reload the firewall
firewall-cmd --reload

# Display information about the installed components
echo "Installation completed. Please check the configurations for each component."

# Show error log if it's not empty
if [ -s installation_errors.log ]; then
  echo "Installation encountered errors. Please review the error log:"
  cat installation_errors.log
fi

