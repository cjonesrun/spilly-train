#!/bin/bash
#FreeDNS updater script

set -x
. ../freedns.apikey
. /home/pi/strongdns_update_url.key

echo $KEY
sudo wget -O - http://sync.afraid.org/u/$KEY/ >> /var/log/freedns_sarcastico_net.log 2>&1 &

sudo wget -O /var/log/freedns_update.log - http://sync.afraid.org/u/$KEY/

# update the dns service in the event that my ip changes...
echo "[`date`] updating ip at $DNS_SERVICE_URL" >> /var/log/strongdns.log 2>&1 &
OUTPUT=`curl $DNS_SERVICE_URL`
echo "[`date`] $OUTPUT" >> /var/log/strongdns.log 2>&1 &

