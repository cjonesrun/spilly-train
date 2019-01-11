#!/bin/bash

# references: 
https://github.com/Fusl/opennic-resolvconf-update
# https://github.com/kewlfft/opennic-up

set -x

DATE=`date +"%Y-%m-%d"`
DIR="/tmp/opennic_opennic_update"
OUTPUT="$DIR/resolv.conf"
LOG="/var/log/dns_opennic_update.log"

URL="https://api.opennicproject.org/geoip/?bare&ipv=4&res=100000"

rm -rf $DIR
mkdir -p $DIR

pushd $DIR
curl "$URL" | awk '{print "nameserver " $1}'  > $OUTPUT

sudo cp $OUTPUT /etc
sudo chown root:root /etc/resolv.conf

cat $LOG > $DATE.log
echo "`date` updated /etc/resolv.conf from $URL" >> $DATE.log

sudo /etc/init.d/dnsmasq restart
echo "`date` restarted dnsmasq" >> $DATE.log
sudo mv $DATE.log $LOG

popd
rm -rf $DIR
