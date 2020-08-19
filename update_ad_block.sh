#!/bin/bash

set -x

# source in the strong dns url (contains api key)
. /home/pi/spilly-train/strongdns_update_url.properties

DATE=`date +"%Y-%m-%d"`
DIR="/tmp/adblock_update"
OUTPUT="$DIR/hosts.$DATE"
LOG="/var/log/adblock_update.log"

URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts"

rm -rf $DIR
mkdir -p $DIR

pushd $DIR
wget -O $OUTPUT $URL

cp /home/pi/hosts.orig $DIR/hosts.orig
cat $DIR/hosts.orig $OUTPUT > $DIR/hosts

sudo cp $DIR/hosts /etc
sudo chown root:root /etc/hosts

cat $LOG > $DATE.log
echo "[`date`] updated /etc/hosts from $URL" >> $DATE.log

# update the dns service in the event that my ip changes...
echo "[`date`] updating ip at $DNS_SERVICE_URL" >> $DATE.log
OUTPUT=`curl $DNS_SERVICE_URL`
echo "[`date`] $OUTPUT" >> $DATE.log

sudo mv $DATE.log $LOG

popd
rm -rf $DIR

sudo /etc/init.d/dnsmasq restart
