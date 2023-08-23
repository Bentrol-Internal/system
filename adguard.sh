# This script will download, install, and configure adguard home on a ubuntu server
# 
# Resources
# https://www.smarthomebeginner.com/install-adguard-home-on-ubuntu/
# https://github.com/AdguardTeam/AdGuardHome/wiki/FAQ#bindinuse
#

# This probably a fresh install so..
sudo apt update
sudo apt upgrade -y

# Ubuntu preparation
sudo mkdir -p /etc/systemd/resolved.conf.d

sudo printf "[Resolve]\nDNS=127.0.0.1\nDNSStubListener=no" >> /etc/systemd/resolved.conf.d/adguardhome.conf

sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

sudo systemctl reload-or-restart systemd-resolved

# Download
curl -LO https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_amd64.tar.gz

# Extract the tar
tar -vxf AdGuardHome_linux_amd64.tar.gz

# Move to predefined locations
sudo mkdir /opt/AdGuardHome
sudo mv ~/AdGuardHome/AdGuardHome /opt/AdGuardHome/

# Set permissions exclusively for root
sudo chown -R root:root /opt/AdGuardHome
sudo chmod -R o-rwx /opt/AdGuardHome

# Set file-level permission for root
sudo apt install acl
sudo setfacl -d -m o::--- /opt/AdGuardHome

# Run the installer
sudo /opt/AdGuardHome/AdGuardHome -s install

# Allow firewall access to the configuration interface @ :3000
sudo ufw allow 3000/tcp

echo "Your time to shine!"
echo "You need to access the web interface of adguard from your browser at <SERVER IP>:3000"
echo "Once configuration is done, run the adguard-fw.sh script"
