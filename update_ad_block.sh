#!/bin/bash

set -x

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
cat $DIR/hosts.orig $OUTPUT | grep -v "fe80::1%lo0" > $DIR/hosts

sudo cp $DIR/hosts /etc
sudo chown root:root /etc/hosts

cat $LOG > $DATE.log
echo "[`date`] updated /etc/hosts from $URL" >> $DATE.log

sudo mv $DATE.log $LOG

popd
rm -rf $DIR

sudo /etc/init.d/dnsmasq restart
