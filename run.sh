#!/bin/bash

# Example run: ./run.sh phishingdomain.com www.phishingdomain.com

HOST=$1
INSTALLPATH=$(pwd)

service gophish stop

# Install Go
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install build-essential

wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
tar -xvf go1.13.3.linux-amd64.tar.gz
rm go1.13.3.linux-amd64.tar.gz
mv go /usr/local
export GOROOT=/usr/local/go
export GOPATH=$INSTALLPATH/../
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

apt-get install sqlite3

# Install GoPhish
go get -d -v ./...
go build -v ./...

# Generate SSL certificate
wget https://dl.eff.org/certbot-auto
mv certbot-auto /usr/local/bin/certbot-auto
chown root /usr/local/bin/certbot-auto
chmod 0755 /usr/local/bin/certbot-auto
/usr/local/bin/certbot-auto certonly -d $HOST -n --standalone --agree-tos --email info@onvio.nl

# Create config
echo '{
	"admin_server": {
		"listen_url": "127.0.0.1:3333",
		"use_tls": true,
		"cert_path": "/etc/letsencrypt/live/$HOST/fullchain.pem",
		"key_path": "/etc/letsencrypt/live/$HOST/privkey.pem"
	},
	"phish_server": {
		"listen_url": "0.0.0.0:443",
		"use_tls": true,
		"cert_path": "/etc/letsencrypt/live/$HOST/fullchain.pem",
		"key_path": "/etc/letsencrypt/live/$HOST/privkey.pem"
	},
	"db_name": "sqlite3",
	"db_path": "gophish.db",
	"migrations_prefix": "db/db_",
	"contact_address": "",
	"logging": {
		"filename": ""
	}
}' > $INSTALLPATH/config.json

# Start service
echo '#!/bin/bash
### BEGIN INIT INFO
# Provides:          gophish
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Gophish service
### END INIT INFO

processName=Gophish
process=gophish
appDirectory=$INSTALLPATH/
logfile=/var/log/gophish/gophish.log
errfile=/var/log/gophish/gophish.error

start() {
    echo "Starting "${processName}"..."
    cd ${appDirectory}
    nohup ./$process >>$logfile 2>>$errfile &
    sleep 1
}

stop() {
    echo $"Stopping "${processName}"..."
    pid=$(pidof gophish)
    kill -9 $pid
    sleep 1
}

status() {
    pid=$(/usr/sbin/pidof ${process})
    if [[ "$pid" != "" ]]; then
        echo ${processName}" is running..."
    else
        echo ${processName}" is not running..."
    fi
}' > /etc/init.d/gophish

mkdir -p /var/log/gophish
chmod +x /etc/init.d/gophish
update-rc.d gophish enable
update-rc.d gophish defaults
service gophish start