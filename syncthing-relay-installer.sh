#!/bin/bash
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/syncthing/relaysrv/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/syncthing/relaysrv/releases/download/$LATEST_VERSION/strelaysrv-linux-amd64-$LATEST_VERSION.tar.gz"

export DEBIAN_FRONTEND=noninteractive

apt update && apt -y full-upgrade
apt clean && apt autoclean && apt autoremove

apt -y install fail2ban

ufw limit in ssh
ufw allow in 22067/tcp
ufw allow in 22070/tcp
ufw --force enable

wget $ARTIFACT_URL
tar zxvf strelaysrv-linux-amd64-$LATEST_VERSION.tar.gz
mv strelaysrv-linux-amd64-$LATEST_VERSION/strelaysrv /usr/local/bin
chmod +x /usr/local/bin/

useradd relaysrv
mkdir /etc/relaysrv
chown relaysrv /etc/relaysrv

cat << EOT >> /etc/systemd/system/relaysrv.service
[Unit]
Description=Syncthing Relay Daemon
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=simple
ExecStart=/usr/local/bin/strelaysrv -keys=/etc/relaysrv -provided-by='my little syncthing server'
User=relaysrv
[Install]
WantedBy=multi-user.target
EOT

rm -rf strelaysrv-linux-amd64-$LATEST_VERSION
rm strelaysrv-linux-amd64-$LATEST_VERSION.tar.gz

systemctl daemon-reload
systemctl enable relaysrv
systemctl start relaysrv

sleep 10

reboot