#!/bin/bash
#FreeDNS and StrongDNS update script

set -x
. /home/pi/conf/freedns.apikey
. /home/pi/conf/strongdns_update_url.key

LOG1=/var/log/freedns_update.log
TMPLOG1=/tmp/tmp1.log
cat $LOG1 > $TMPLOG1


CURRENT_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
echo "[`date`] updating freedns entry at http://sync.afraid.org/u/$KEY/" >> $TMPLOG1 2>&1 &
OUTPUT=`curl http://sync.afraid.org/u/$KEY/` 
echo "[`date`] $OUTPUT" >> $TMPLOG1 2>&1 &
sudo mv $TMPLOG1 $LOG1

LOG2=/var/log/strongdns_update.log
TMPLOG2=/tmp/tmp2.log
cat $LOG2 > $TMPLOG2

# update the dns service in the event that my ip changes...
echo "[`date`] current ip: $CURRENT_IP" >> $TMPLOG2 2>&1 &
echo "[`date`] updating ip at $DNS_SERVICE_URL" >> $TMPLOG2 2>&1 &
OUTPUT=`curl $DNS_SERVICE_URL`
echo "[`date`] $OUTPUT" >> $TMPLOG2 2>&1 &
sudo mv $TMPLOG2 $LOG2
