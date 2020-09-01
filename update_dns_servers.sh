#!/bin/bash

# get 20+ dns servers from open nic project and drop them into /etc/dnsmasq.d/*.conf
#
# references: 
# https://github.com/Fusl/opennic-resolvconf-update
# https://github.com/kewlfft/opennic-up

set -x

DATE=`date +"%Y-%m-%d"`
TMP_DIR="/tmp/opennic_opennic_update"
TARGET_DIR="/etc/dnsmasq.d"
CONF="03-pihole-upstream-dns-servers.conf"

OUTPUT="$TMP_DIR/$CONF"
LOG="/var/log/dns_opennic_update.log"
URL="https://api.opennicproject.org/geoip/?bare&ipv=4&res=100000"

rm -rf $TMP_DIR
mkdir -p $TMP_DIR
pushd $TMP_DIR

curl "$URL" | awk '{print "server=" $1}'  > $OUTPUT
sudo chown root:root $OUTPUT
sudo cp $OUTPUT $TARGET_DIR

cat $LOG > $DATE.log
echo "`date` updated $TARGET_DIR/$CONF from $URL" >> $DATE.log
cat $OUTPUT >> $DATE.log

echo "`date` restarting pi-hole" >> $DATE.log
sudo systemctl restart pihole-FTL.service
echo "`date` restarted pi-hole" >> $DATE.log
sudo mv $DATE.log $LOG

popd
rm -rf $TMP_DIR
