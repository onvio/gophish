#!/bin/bash

# Example run: 
# cd /opt && git clone https://github.com/onvio/gophish.git && bash gophish/run.sh phisher.com,www.phisher.com

HOST=$1

systemctl stop gophish.service

# Install Go
apt-get update
apt-get -y upgrade
apt-get -y install build-essential
apt-get -y install sqlite3

rm -r /usr/local/go
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
tar -xvf go1.13.3.linux-amd64.tar.gz
rm go1.13.3.linux-amd64.tar.gz
mv go /usr/local

# Set GoPath to one directory up from where project is cloned
parentDir="$(dirname "$(pwd)")"

export GOROOT=/usr/local/go
export GOPATH=$parentDir
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Install GoPhish
go get -d -v ./...
go build -v ./...
go install .

# Generate SSL certificate
wget https://dl.eff.org/certbot-auto
mv certbot-auto /usr/local/bin/certbot-auto
chown root /usr/local/bin/certbot-auto
chmod 0755 /usr/local/bin/certbot-auto
/usr/local/bin/certbot-auto certonly -d $HOST -n --standalone --agree-tos --email info@onvio.nl

# Create config
echo "{
	\"admin_server\": {
		\"listen_url\": \"0.0.0.0:3333\",
		\"use_tls\": true,
		\"cert_path\": \"/etc/letsencrypt/live/$HOST/fullchain.pem\",
		\"key_path\": \"/etc/letsencrypt/live/$HOST/privkey.pem\"
	},
	\"phish_server\": {
		\"listen_url\": \"0.0.0.0:443\",
		\"use_tls\": true,
		\"cert_path\": \"/etc/letsencrypt/live/$HOST/fullchain.pem\",
		\"key_path\": \"/etc/letsencrypt/live/$HOST/privkey.pem\"
	},
	\"db_name\": \"sqlite3\",
	\"db_path\": \"gophish.db\",
	\"migrations_prefix\": \"db/db_\",
	\"contact_address\": \"\",
	\"logging\": {
		\"filename\": \"\"
	}
}" > $GOPATH/gophish/config.json

# Start service
echo "[Unit]
Description=Gophishtest

[Service]
WorkingDirectory=/opt/gophish
ExecStart=/opt/gophish/gophish
Type=simple

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/gophish.service

systemctl daemon-reload
service gophish start
systemctl start gophish.service